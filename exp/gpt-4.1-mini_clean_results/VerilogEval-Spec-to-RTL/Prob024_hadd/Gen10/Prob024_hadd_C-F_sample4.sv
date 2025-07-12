module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

wire xor_out;
wire and_out;

assign xor_out = a ^ b;    // XOR operation for sum
assign and_out = a & b;    // AND operation for carry-out

assign sum = xor_out;
assign cout = and_out;

endmodule