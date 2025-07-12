module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Generate out_both
always @(*) begin
    out_both[99] = 0; // Since the last bit has no neighbor to the left
    for (int i = 0; i < 99; i++) begin
        out_both[i] = in[i] && in[i+1]; // Compare each bit with its neighbor to the left
    end
end

// Generate out_any
always @(*) begin
    out_any[0] = 0; // Since the first bit has no neighbor to the right
    for (int i = 1; i < 100; i++) begin
        out_any[i] = in[i] || in[i-1]; // Compare each bit with its neighbor to the right
    end
end

// Generate out_different
always @(*) begin
    for (int i = 0; i < 99; i++) begin
        out_different[i] = in[i] !== in[i+1]; // Compare each bit with its neighbor to the left
    end
    out_different[99] = in[99] !== in[0]; // Treat the vector as wrapping around
end

endmodule