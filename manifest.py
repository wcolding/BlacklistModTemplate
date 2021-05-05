import os
import hashlib

srcdir = "src"
baseLevel = os.listdir(srcdir)
baseDir = os.getcwd() + "\\" + srcdir + "\\"

uncompressed = os.getcwd() + "\\UMD\\Uncompressed.umd"
umdFile = open(uncompressed, "rb")
umdData = umdFile.read()

def Xor(data):
    dataArray = bytearray(data)
    decrypted = dataArray
    size = len(dataArray)
    for i in range(size):
        decrypted[i] = dataArray[i] ^ 183 # Key is 0xB7
    return decrypted

def GetOffset(umd, file):
    if file in umd:
        return umd.index(file)
    else:
        return -1

def SwapFile(filestring):
    f = open(filestring, "rb")
    fData = f.read()
    newData = Xor(fData)
    f.close()

    e = open(filestring, "wb")
    e.write(newData)
    e.close()

filelist = []

def ReadFiles(files, dir=""):
    for file in files:
        dirstring = baseDir + dir
        filestring = dirstring + file
        if "." in file:
            # This is a file, add it to the manifest
            
            # Unumd applies Conviction's 0xB7 XOR erroneously, so swap it back
            SwapFile(filestring)

            curFile = open(filestring, "rb")
            curData = curFile.read()

            md5 = hashlib.md5(str(curData).encode('utf-8')).hexdigest()
            filelist.append(str(dir + file + "," + str(GetOffset(umdData, curData)) + "," + str(curFile.tell()) + "," + md5))
            curFile.close()
        else:
            # This is a folder, search its contents
            nextLevel = os.listdir(filestring)
            nextDir = dir + file + "\\"
            ReadFiles(nextLevel, nextDir)

ReadFiles(baseLevel)
umdFile.close()

manifest = open("manifest.txt", "w")

for line in filelist:
    print(line)
    manifest.write(line + "\n")

manifest.close()