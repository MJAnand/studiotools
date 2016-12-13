#!/usr/bin/python

import pyPdf
import sys


def split (input_file, output_format, start_number):
    """
    splits a pdf file into single page pdfs
    """
    
    input = pyPdf.PdfFileReader( open(input_file, "rb") )
    
    for i in range(input.numPages):
        output = pyPdf.PdfFileWriter()
        output.addPage(input.getPage(i))
        
        with open(output_format %("%03d" % (i + start_number)), "wb") as outputStream:
            output.write(outputStream)

    return True


def main (args):
    # at least 2 arguments are needed
    if len(args) < 3:
        print "Usage: %s input" % args[0]
        return
    
    input_file = args[1]
    start_num = args[2]
    
    if input_file.find(".") != -1:
        # output file name: input-01.ext, input-02.ext, ...
        
        filename, extension = input_file.rsplit(".", 1)
        path, filename = filename.rsplit("/", 1)
        print filename
        path = path + "/"
        output_format = "%s%%s %s.%s" % (path, filename, extension)
        print output_format
        split(input_file, output_format, int(float(start_num)))
        
    else:
        # file has no extension part. output file names will be input-01,
        # input-02, ...
        split(input_file, "%s-%%s" % input_file)


if __name__ == "__main__":
    main(sys.argv)
