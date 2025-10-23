module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

wire xor_ab = a ^ b;
wire and_ab = a & b;

assign sum = xor_ab;
assign cout = and_ab;

endmodule