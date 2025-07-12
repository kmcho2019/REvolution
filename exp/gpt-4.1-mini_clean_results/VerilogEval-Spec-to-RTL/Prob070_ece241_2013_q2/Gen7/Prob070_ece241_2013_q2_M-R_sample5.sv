module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in_vec;
assign in_vec = {a, b, c, d};

// Sum-of-products: output 1 for inputs 2, 7, 15
assign out_sop = (in_vec == 4'd2) | (in_vec == 4'd7) | (in_vec == 4'd15);

// Product-of-sums form: logically equivalent POS from negation of SOP
// out = 1 for 2,7,15; zero for specified inputs; others don't care
// Implement POS by DeMorgan on SOP
assign out_pos = ~((in_vec != 4'd2) & (in_vec != 4'd7) & (in_vec != 4'd15));

endmodule