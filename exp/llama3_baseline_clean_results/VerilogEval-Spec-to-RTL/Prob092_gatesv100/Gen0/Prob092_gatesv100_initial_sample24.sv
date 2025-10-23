module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Compute out_both
always @(*)
begin
    out_both[99] = 1'b0; // MSB has no neighbor to the left
    for (int i = 98; i >= 0; i--)
        out_both[i] = in[i] && in[i + 1];
end

// Compute out_any
always @(*)
begin
    out_any[0] = 1'b0; // LSB has no neighbor to the right
    for (int i = 1; i <= 99; i++)
        out_any[i] = in[i] || in[i - 1];
end

// Compute out_different
always @(*)
begin
    for (int i = 99; i >= 0; i--)
        out_different[i] = in[i] !== in[(i + 1) % 100];
end

endmodule