module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in_num;
assign in_num = {a,b,c,d};

// Define constants for the numbers to compare
localparam [3:0] NUM_0  = 4'd0;
localparam [3:0] NUM_1  = 4'd1;
localparam [3:0] NUM_2  = 4'd2;
localparam [3:0] NUM_4  = 4'd4;
localparam [3:0] NUM_5  = 4'd5;
localparam [3:0] NUM_6  = 4'd6;
localparam [3:0] NUM_7  = 4'd7;
localparam [3:0] NUM_9  = 4'd9;
localparam [3:0] NUM_10 = 4'd10;
localparam [3:0] NUM_13 = 4'd13;
localparam [3:0] NUM_14 = 4'd14;
localparam [3:0] NUM_15 = 4'd15;

// out_sop is 1 for input = 2, 7, or 15
assign out_sop = (in_num == NUM_2) | (in_num == NUM_7) | (in_num == NUM_15);

// out_pos is product of sums corresponding to zeros (0,1,4,5,6,9,10,13,14)
// Implemented as NOT of OR of equalities to zero values
assign out_pos = ~(
    (in_num == NUM_0)  |
    (in_num == NUM_1)  |
    (in_num == NUM_4)  |
    (in_num == NUM_5)  |
    (in_num == NUM_6)  |
    (in_num == NUM_9)  |
    (in_num == NUM_10) |
    (in_num == NUM_13) |
    (in_num == NUM_14)
);

endmodule