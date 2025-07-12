module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Initialize output vectors
genvar i;
generate
    for (i = 0; i <= 99; i++) begin
        // out_both: Check if current bit and its left neighbor are both '1'
        if (i == 99) begin
            assign out_both[i] = 0; // No left neighbor for the last bit
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // out_any: Check if current bit or its right neighbor is '1'
        if (i == 0) begin
            assign out_any[i] = 0; // No right neighbor for the first bit
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // out_different: Check if current bit is different from its left neighbor (wrapping around)
        if (i == 99) begin
            assign out_different[i] = in[i] ^ in[0]; // Wrap around to the start for the last bit
        end else begin
            assign out_different[i] = in[i] ^ in[i+1];
        end
    end
endgenerate

endmodule