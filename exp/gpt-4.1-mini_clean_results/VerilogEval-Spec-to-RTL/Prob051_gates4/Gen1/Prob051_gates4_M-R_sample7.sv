module TopModule(
    input  [3:0] in,
    output reg   out_and,
    output reg   out_or,
    output reg   out_xor
);

always @(*) begin
    out_and = &in;  // reduction AND of all bits in input
    out_or  = |in;  // reduction OR of all bits in input
    out_xor = ^in;  // reduction XOR of all bits in input
end

endmodule