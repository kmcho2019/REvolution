module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Generate out_both
always @(in) begin
    out_both[99] = 0; // Most significant bit has no neighbor to the left
    for (int i = 98; i >= 0; i--) begin
        out_both[i] = in[i] & in[i+1];
    end
end

// Generate out_any
always @(in) begin
    out_any[0] = 0; // Least significant bit has no neighbor to the right
    for (int i = 1; i <= 99; i++) begin
        out_any[i] = in[i] | in[i-1];
    end
end

// Generate out_different
always @(in) begin
    for (int i = 0; i <= 99; i++) begin
        if (i == 99) begin
            out_different[i] = in[i]!= in[0]; // Wrap-around case
        end else begin
            out_different[i] = in[i]!= in[i+1];
        end
    end
end

endmodule