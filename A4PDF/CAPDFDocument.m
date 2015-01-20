//
//  CAPDFDocument.m
//  A4PDF
//
//  Created by Cameron Milsom on 10/2/14.
//  Copyright (c) 2014 cmilsom. All rights reserved.
//


#import "CAPDFDocument.h"

@implementation CAPDFDocument

@synthesize pdf_array;
@synthesize pdf_pages;
@synthesize pdf_notes;
@synthesize index1;
@synthesize search_count;
@synthesize search_results;
@synthesize searched_text;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"CAPDFDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    PDFDocument *pdfDoc;
    pdfDoc = [[PDFDocument alloc] initWithURL: [NSURL fileURLWithPath: @"/home/cshome/c/cmilsom/346/A4PDF/BlankA4PDF.pdf"]];
    [_thepdfview setDocument: pdfDoc];
    [[self thewindow] addChildWindow:[self notesPanel] ordered:NSWindowBelow];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (IBAction)searchPDF: (id) sender
{
    //Check if we have searched before
    if ([searched_text isEqualToString: [_searchtext stringValue]]) {
        [_thepdfview setCurrentSelection:search_results[search_count]];
        [_thepdfview goToSelection: search_results[search_count]];
        search_count = (search_count+1) % [search_results count];
        return;
    }
    search_count = 0;
    searched_text = [_searchtext stringValue];
    search_results = [[NSMutableArray alloc] init];
    search_results = [[[_thepdfview document] findString: [_searchtext stringValue] withOptions:NSCaseInsensitiveSearch] mutableCopy];
    if ([search_results count] == 0) { //Exits if no matches are found
        searched_text = nil;
        return;
    }
    [_thepdfview setCurrentSelection:search_results[search_count]];
    [_thepdfview goToSelection: search_results[search_count]];
    search_count = (search_count+1) % [search_results count];
}



- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (IBAction)switchAutoScale :(id)sender
{
    if ([_thepdfview autoScales] == NO) {
        [_thepdfview setAutoScales: YES];
    } else {
        [_thepdfview setAutoScales:NO];
    }
}

/* Opens PDFs using the open panel interface */
- (IBAction)openPDFs:(id) sender
{
    
    NSOpenPanel *opener = [[NSOpenPanel alloc] init];
    opener.allowsMultipleSelection = true;
    opener.canChooseFiles = true;
    [opener runModal];
    NSArray *url_array = [opener URLs];
    BOOL wasEmpty = NO;
    
    //If we haven't got any files, set up arrays for the files.
    if (pdf_array == nil)
    {
        wasEmpty = YES;
        index1 = 0;
        pdf_notes = [[NSMutableArray alloc] init];
        pdf_pages = [[NSMutableArray alloc] init];
        pdf_array = [[NSMutableArray alloc] init];
    }
    
    for (int i=0; i < [url_array count]; i++) {
        PDFDocument *pdfDoc = [[PDFDocument alloc] initWithURL: url_array[i]];
        [pdf_notes addObject: @" "];
        [pdf_pages addObject: [NSNull null]];
        [pdf_array addObject: pdfDoc];
    }
    NSLog(@"%ld", [pdf_array count]);
    if (wasEmpty) { //This will probably cause a bug that I will not fix :)
        [_thepdfview setDocument: pdf_array[0]];
        [_thepdfview goToFirstPage:sender];
        [_thetext setStringValue: @" "];
        [_thewindow setTitle: [[[_thepdfview document] documentURL] lastPathComponent]];
    }
}



//This changes everything in the window to appropriately display the next document
- (IBAction)nextDocument:(id) sender
{
    if (pdf_array == nil || [pdf_array count] <= 1)
        return; //No need to go to next doc.
    
    if ([_thetext stringValue] == nil) {
        pdf_notes[index1] = @"";
    } else {
        pdf_notes[index1] = [_thetext stringValue];
    }
    pdf_pages[index1] = [_thepdfview currentDestination]; //Set the page for the current doc as the current page
    index1 = (index1+1) % ([pdf_array count]);
    [_thetext setStringValue: pdf_notes[index1]];
    if (pdf_pages[index1] == [NSNull null]) {
        [_thepdfview setDocument: pdf_array[index1]];
        [_thewindow setTitle: [[[_thepdfview document] documentURL] lastPathComponent]];
        [_thepdfview goToFirstPage: sender];
    } else {
        [_thepdfview setDocument: pdf_array[index1]];
        [_thewindow setTitle: [[[_thepdfview document] documentURL] lastPathComponent]];
        [_thepdfview goToDestination:pdf_pages[index1]];
    }
}

//This changes everything in the window to appropriately display the previous document
- (IBAction)previousDocument:(id) sender
{
    if (pdf_array == nil || [pdf_array count] <= 1)
        return; //No need to go to previous doc.
    
    if ([_thetext stringValue] == nil) {
        pdf_notes[index1] = @"";
    } else {
        pdf_notes[index1] = [_thetext stringValue];
    }
    
    pdf_pages[index1] = [_thepdfview currentDestination]; //Set the page for the current doc as the current page
    if (index1 == 0) {
        index1 = [pdf_array count]-1;
    } else {
        index1 = (index1-1) % ([pdf_array count]);
    }
    [_thetext setStringValue: pdf_notes[index1]];
    if (pdf_pages[index1] == [NSNull null]) {
        [_thepdfview setDocument: pdf_array[index1]];
        [_thewindow setTitle: [[[_thepdfview document] documentURL] lastPathComponent]];
        [_thepdfview goToFirstPage: sender];
    } else {
        [_thepdfview setDocument: pdf_array[index1]];
        [_thewindow setTitle: [[[_thepdfview document] documentURL] lastPathComponent]];
        [_thepdfview goToDestination:pdf_pages[index1]];
    }
}

@end
