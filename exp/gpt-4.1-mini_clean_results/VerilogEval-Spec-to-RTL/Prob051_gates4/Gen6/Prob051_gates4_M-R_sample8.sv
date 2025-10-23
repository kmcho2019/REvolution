module TopModule(
    input  [3:0] in,
    output reg   out_and,
    output reg   out_or,
    output reg   out_xor
);

always @(*) begin
    out_and = &in;  // reduction AND
    out_or  = |in;  // reduction OR
    out_xor = ^in;  // reduction XOR
end

endmodule