module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(a, b, c, d) begin
    // Simplified expression based on Karnaugh map analysis
    out = (a ^ b) ^ (c ^ d);
end

endmodule