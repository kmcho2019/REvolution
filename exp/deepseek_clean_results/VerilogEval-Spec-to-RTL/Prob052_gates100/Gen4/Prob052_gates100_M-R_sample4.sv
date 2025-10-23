module TopModule (
    input [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(*) begin
        out_and = &in;  // 100-bit AND reduction
        out_or  = |in;  // 100-bit OR reduction
        out_xor = ^in;  // 100-bit XOR reduction
    end

endmodule