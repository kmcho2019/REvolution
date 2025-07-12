module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care
    output out
);

wire [3:0] data_inputs;

// Define data inputs based on Karnaugh map rows (cd):
// Indexing data_inputs: 0->00, 1->01, 2->10, 3->11 (cd values)
// Each bit corresponds to ab=00,01,10,11 (in order)
// We'll build the logic to select the correct data input based on c,d and then select output based on a,b.

assign data_inputs[0] = 1'b0; // cd=00: from the map: positions 00=0, 01=0 (map cols ordered 01,00,10,11 but for simplicity we choose 00..11)
assign data_inputs[1] = 1'b0; // cd=01
assign data_inputs[2] = 1'b1; // cd=10
assign data_inputs[3] = 1'b1; // cd=11

// First Mux: selects output based on ab = a,b
wire ab_select = {a,b};

// Second Mux: selects data_inputs based on cd = c,d
wire [1:0] cd_select = {c,d};

// Output is selected as data_inputs indexed by cd_select, and within that value output is according to ab_select

// To implement this, we flatten the map: For each cd row, the Karnaugh map gives output for columns ab=01,00,10,11:
// Let's map ab columns order: 01(1),00(0),10(2),11(3) as indexes 0..3, but for simplicity,
// we reorder Karnaugh map to align ab = {a,b} as 2-bit index (00,01,10,11).

// We can precompute values for each (c,d) and (a,b):

// Let's create a 4-bit vector for each cd row, ordered by ab=00..11:
// cd=00: d,0,1,1 => for ab=00->0, ab=01->d, ab=10->1, ab=11->1
// We choose d=0 for simplicity.

// So row cd=00 data inputs by ab index:
// ab=00 => 0
// ab=01 => 0 (choose d=0)
// ab=10 => 1
// ab=11 => 1
wire [3:0] row_00 = 4'b1100; // bits ordered as ab=11,10,01,00, reversed to 00..11 order: ab=00(LSB), ab=01, ab=10, ab=11(MSB)
// We'll assign ab bits as: ab=00->0, ab=01->1, ab=10->2, ab=11->3
// Let's define with ab as {a,b}, a MSB, so ab=00(0),01(1),10(2),11(3)

// So row_00: ab=00(0):0, ab=01(1):0, ab=10(2):1, ab=11(3):1 -> 4'b1100 (from MSB to LSB)

// cd=01: 0,0,d,d => ab=00=0, ab=01=0, ab=10=d=0, ab=11=d=0
wire [3:0] row_01 = 4'b0000;

// cd=10: 0,1,1,1 => ab=00=0, ab=01=1, ab=10=1, ab=11=1
wire [3:0] row_10 = 4'b1110;

// cd=11: 0,1,1,1 => same as cd=10
wire [3:0] row_11 = 4'b1110;

// Select row based on cd = {c,d}
wire [3:0] selected_row;
assign selected_row = (cd_select == 2'b00) ? row_00 :
                      (cd_select == 2'b01) ? row_01 :
                      (cd_select == 2'b10) ? row_10 :
                                            row_11 ;

// Select bit from selected_row based on ab = {a,b}
assign out = selected_row[{a,b}];

endmodule