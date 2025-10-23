module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Generate out_both
always @(in) begin
    out_both[99] = 0; // No left neighbor for in[99]
    for (int i = 0; i < 99; i++) begin
        out_both[i] = in[i] & in[i + 1];
    end
end

// Generate out_any
always @(in) begin
    out_any[0] = 0; // No right neighbor for in[0]
    for (int i = 1; i < 100; i++) begin
        out_any[i] = in[i] | in[i - 1];
    end
end

// Generate out_different
always @(in) begin
    for (int i = 0; i < 99; i++) begin
        out_different[i] = in[i] ^ in[i + 1];
    end
    // Wrap around for in[99]
    out_different[99] = in[99] ^ in[0];
end

endmodule