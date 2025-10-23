module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular left-shifted version of input (for left neighbors)
    wire [99:0] left_shifted = {in[98:0], in[99]};

    // Circular right-shifted version of input (for right neighbors)
    wire [99:0] right_shifted = {in[0], in[99:1]};

    // Processing elements for each bit
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : pe
            // out_both: current AND left (except MSB)
            assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & left_shifted[i]);

            // out_any: current OR right (except LSB)
            assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | right_shifted[i]);

            // out_different: current XOR left (all bits, wrap-around)
            assign out_different[i] = in[i] ^ left_shifted[i];
        end
    endgenerate

endmodule