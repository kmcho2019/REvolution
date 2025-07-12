module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in = {a,b,c,d};

// Define the minterms that produce out=1
wire is_2  = (in == 4'b0010); // decimal 2
wire is_7  = (in == 4'b0111); // decimal 7
wire is_15 = (in == 4'b1111); // decimal 15

// Define the minterms that produce out=0
wire is_0  = (in == 4'b0000);
wire is_1  = (in == 4'b0001);
wire is_4  = (in == 4'b0100);
wire is_5  = (in == 4'b0101);
wire is_6  = (in == 4'b0110);
wire is_9  = (in == 4'b1001);
wire is_10 = (in == 4'b1010);
wire is_13 = (in == 4'b1101);
wire is_14 = (in == 4'b1110);

// out_sop: 1 if input is 2,7 or 15
assign out_sop = is_2 | is_7 | is_15;

// out_pos: 0 if input is one of the zeros above; 1 otherwise.
// Implemented as NOR of all zero conditions:
assign out_pos = ~(is_0 | is_1 | is_4 | is_5 | is_6 | is_9 | is_10 | is_13 | is_14);

endmodule