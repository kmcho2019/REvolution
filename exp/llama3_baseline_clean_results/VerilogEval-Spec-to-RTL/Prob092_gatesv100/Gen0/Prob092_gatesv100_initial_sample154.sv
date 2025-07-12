module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Initialize output vectors
assign out_both[99] = 1'b0; // MSB has no left neighbour, so always 0
assign out_any[0] = 1'b0; // LSB has no right neighbour, so always 0

// Generate out_both vector
genvar i;
generate
    for (i = 98; i >= 0; i--) begin
        assign out_both[i] = in[i] & in[i+1];
    end
endgenerate

// Generate out_any vector
generate
    for (i = 1; i <= 99; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate

// Generate out_different vector
generate
    for (i = 98; i >= 0; i--) begin
        assign out_different[i] = in[i] ^ in[i+1];
    end
    assign out_different[99] = in[99] ^ in[0]; // Wrap around for MSB
endgenerate

endmodule