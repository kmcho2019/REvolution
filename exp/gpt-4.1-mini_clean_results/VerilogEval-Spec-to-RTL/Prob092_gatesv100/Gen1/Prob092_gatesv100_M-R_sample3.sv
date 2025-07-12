module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

integer i;
always @(*) begin
    // Compute out_both
    for (i = 0; i < 99; i = i + 1) begin
        out_both[i] = in[i] & in[i+1];
    end
    out_both[99] = 1'b0; // No left neighbor for in[99]

    // Compute out_any
    out_any[0] = 1'b0; // No right neighbor for in[0]
    for (i = 1; i < 100; i = i + 1) begin
        out_any[i] = in[i] | in[i-1];
    end

    // Compute out_different with wrapping
    for (i = 0; i < 99; i = i + 1) begin
        // left neighbor for in[i] is in[i+1]
        out_different[i] = in[i] ^ in[i+1];
    end
    out_different[99] = in[99] ^ in[0]; // wrap around neighbor
end

endmodule