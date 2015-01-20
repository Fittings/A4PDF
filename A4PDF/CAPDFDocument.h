//
//  CAPDFDocument.h
//  A4PDF
//
//  Created by Cameron Milsom on 10/2/14.
//  Copyright (c) 2014 cmilsom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface CAPDFDocument : NSDocument
@property (weak) IBOutlet NSTextField *thetext;
@property (weak) IBOutlet NSTextField *searchtext;
@property (weak) IBOutlet PDFView *thepdfview;
@property (weak) IBOutlet NSWindow *thewindow;
@property (assign) IBOutlet NSWindow *noteswindow;
@property (assign) IBOutlet NSWindow *notesPanel;



@property (strong) NSMutableArray *search_results;
@property (strong) NSMutableArray *pdf_notes;
@property (strong) NSMutableArray *pdf_pages;
@property (strong) NSMutableArray *pdf_array;
@property (strong) NSString *searched_text;
@property(nonatomic, assign) int index1;
@property(nonatomic, assign) int search_count;

- (IBAction)searchPDF: (id) sender;
- (IBAction)switchAutoScale :(id)sender;
- (IBAction)openPDFs:(id) sender; //This is referenced despite the interface not showing that.
- (IBAction)nextDocument:(id) sender;
- (IBAction)previousDocument:(id) sender;


@end
