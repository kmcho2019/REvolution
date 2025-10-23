module TopModule(
    input  [3:0] in,
    output reg   out_and,
    output reg   out_or,
    output reg   out_xor
);

always @(*) begin
    out_and = &in;  // 4-input reduction AND
    out_or  = |in;  // 4-input reduction OR
    out_xor = ^in;  // 4-input reduction XOR
end

endmodule