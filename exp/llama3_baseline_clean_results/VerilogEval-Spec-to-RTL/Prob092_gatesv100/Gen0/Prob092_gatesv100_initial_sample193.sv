module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Initialize out_both, out_any, out_different as 100-bit vectors
// out_both: Both current bit and its left neighbor are '1'
assign out_both[99] = 1'b0; // No left neighbor for in[99]
for (genvar i = 98; i >= 0; i--) begin
    assign out_both[i] = in[i] & in[i+1];
end

// out_any: Either current bit or its right neighbor is '1'
assign out_any[0] = 1'b0; // No right neighbor for in[0]
for (genvar i = 1; i <= 99; i++) begin
    assign out_any[i] = in[i] | in[i-1];
end

// out_different: Current bit is different from its left neighbor (wrap around)
assign out_different[99] = in[99] ^ in[0]; // Wrap around for in[99]
for (genvar i = 98; i >= 0; i--) begin
    assign out_different[i] = in[i] ^ in[i+1];
end

endmodule