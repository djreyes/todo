//
//  ListViewController.m
//  todo
//
//  Created by Jeremy Reyes on 10/15/13.
//  Copyright (c) 2013 Jeremy Reyes. All rights reserved.
//

#import "ListViewController.h"
#import "TaskCell.h"

@interface ListViewController ()

@property (strong, nonatomic) NSMutableArray *taskArray;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation ListViewController

@synthesize taskArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"To Do List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UINib *customNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TaskCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedTasks = [self.userDefaults objectForKey:@"savedTasks"];
    if (savedTasks != nil)
        self.taskArray = [[NSMutableArray alloc] initWithArray:savedTasks];
    else
        self.taskArray = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.descriptionField.tag = indexPath.row;
    cell.descriptionField.text = [self.taskArray objectAtIndex:indexPath.row];
    cell.descriptionField.delegate = self;
    
    return cell;
}

- (void)saveTasks
{
    [self.userDefaults setObject:self.taskArray forKey:@"savedTasks"];
    [self.userDefaults synchronize];
}

- (IBAction)addTask:(id)sender
{
    NSString *taskDescription = @"New task";
	[self.taskArray insertObject:taskDescription atIndex:0];
    [self saveTasks];
    [self.tableView reloadData];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.taskArray replaceObjectAtIndex:[textField tag] withObject:[textField text]];
    [self setEditing:NO];
    [self saveTasks];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.taskArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveTasks];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *movedTaskDescription = [self.taskArray objectAtIndex:fromIndexPath.row];
    [self.taskArray removeObjectAtIndex:fromIndexPath.row];
    [self.taskArray insertObject:movedTaskDescription atIndex:toIndexPath.row];
    [self saveTasks];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
