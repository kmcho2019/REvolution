module TopModule (
    input  [99:0] in,
    output reg    out_and,  // 100-input AND
    output reg    out_or,   // 100-input OR
    output reg    out_xor   // 100-input XOR (parity)
);

    always @(*) begin
        out_and = &in;  // Reduction AND of all 100 bits
        out_or  = |in;  // Reduction OR of all 100 bits
        out_xor = ^in;  // Reduction XOR (parity) of all 100 bits
    end

endmodule