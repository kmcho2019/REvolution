module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Generate out_both
assign out_both[99] = 1'b0; // Leftmost bit has no left neighbor
for (genvar i = 0; i < 99; i++) begin
    assign out_both[i] = in[i] & in[i+1];
end

// Generate out_any
assign out_any[0] = 1'b0; // Rightmost bit has no right neighbor
for (genvar i = 1; i < 100; i++) begin
    assign out_any[i] = in[i] | in[i-1];
end

// Generate out_different
for (genvar i = 0; i < 100; i++) begin
    assign out_different[i] = in[i] ^ in[(i+1) % 100]; // Wrap-around case
end

endmodule