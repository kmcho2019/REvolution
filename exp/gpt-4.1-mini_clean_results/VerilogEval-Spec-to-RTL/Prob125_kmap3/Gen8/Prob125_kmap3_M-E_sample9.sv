module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The Karnaugh map rows are addressed by (c,d):
// For each row, we create a 2-bit vector representing the column outputs indexed by (a,b):
// Columns: ab = 01, 00, 10, 11 (but we reorder as ab=00,01,10,11 for convenience)
// We'll reorder columns to standard order ab=00,01,10,11:
// Row cd=00: ab=00 -> 0, 01 -> d, 10 -> 1, 11 -> 1
// From the problem's map:
// Row 00 (c=0,d=0): ab=00:0, 01:d, 10:1, 11:1
// Because d is don't-care, assign 0 or 1 as convenient for column ab=01 (which is 1'b1 or 0)
// Let's assign 1 for the don't-care at 01 for better grouping.

// Similarly for other rows (cd):
// 00:  ab=00->0, ab=01->1, ab=10->1, ab=11->1
// 01:  ab=00->0, ab=01->0, ab=10->d, ab=11->d (assign 0 for don't-cares)
// 11:  ab=00->0, ab=01->1, ab=10->1, ab=11->1
// 10:  ab=00->0, ab=01->1, ab=10->1, ab=11->1

// Now each row is a 4-bit vector with bits ordered ab=00,01,10,11:
wire [3:0] row0 = 4'b0111; // 0,1,1,1
wire [3:0] row1 = 4'b0000; // 0,0,0,0 (after assigning don't-cares as 0)
wire [3:0] row3 = 4'b0111; // c=1,d=1 (11), 0,1,1,1
wire [3:0] row2 = 4'b0111; // c=1,d=0 (10), 0,1,1,1

// Select the row based on c and d:
wire [1:0] cd = {c,d};
wire [3:0] selected_row;

assign selected_row = (cd == 2'b00) ? row0 :
                      (cd == 2'b01) ? row1 :
                      (cd == 2'b10) ? row2 :
                                      row3; // cd==11

// Map (a,b) to index into selected_row:
// a,b = 00 -> idx 0
// a,b = 01 -> idx 1
// a,b = 10 -> idx 2
// a,b = 11 -> idx 3

wire [1:0] ab = {a,b};

assign out = selected_row[ab];

endmodule