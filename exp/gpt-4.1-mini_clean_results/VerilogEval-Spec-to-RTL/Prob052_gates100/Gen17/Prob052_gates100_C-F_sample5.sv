module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);

    always @(*) begin
        out_and = &in;  // Reduction AND of all bits
        out_or  = |in;  // Reduction OR of all bits
        out_xor = ^in;  // Reduction XOR of all bits
    end

endmodule