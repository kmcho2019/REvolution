// Module to reverse the bit ordering of a 100-bit input vector
module TopModule(
    input  [99:0] in,  // 100-bit input vector
    output [99:0] out  // 100-bit output vector
);

// Generate block to create assignment statements for bit reversal
genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // Assign each output bit to the corresponding input bit in reverse order
        assign out[99 - i] = in[i];
    end
endgenerate

endmodule