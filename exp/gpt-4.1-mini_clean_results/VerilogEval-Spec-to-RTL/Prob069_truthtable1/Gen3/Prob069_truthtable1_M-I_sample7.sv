module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

wire x1_x2_xor;
wire and_term;

assign x1_x2_xor = x1 ^ x2;
assign and_term = x3 & x1_x2_xor;
assign f = x2 ^ and_term;

endmodule