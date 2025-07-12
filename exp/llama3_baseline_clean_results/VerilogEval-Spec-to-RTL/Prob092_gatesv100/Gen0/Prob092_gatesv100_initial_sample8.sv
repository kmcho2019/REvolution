module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// For out_both, compare each bit with its left neighbor
assign out_both[99] = 1'b0;
for(genvar i = 98; i >= 0; i--) begin
    assign out_both[i] = in[i] & in[i+1];
end

// For out_any, compare each bit with its right neighbor
assign out_any[0] = 1'b0;
for(genvar i = 1; i < 100; i++) begin
    assign out_any[i] = in[i] | in[i-1];
end

// For out_different, compare each bit with its left neighbor (wrapping around for the first bit)
assign out_different[99] = ~in[99] & in[0] | in[99] & ~in[0];
for(genvar i = 98; i >= 0; i--) begin
    assign out_different[i] = ~in[i] & in[i+1] | in[i] & ~in[i+1];
end

endmodule