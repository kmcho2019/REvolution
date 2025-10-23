module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_rotate
            // Compute rotated index for this output bit
            wire [2:0] rotated_idx = (i - ctrl) & 3'b111; // modulo 8 subtraction
            // Select the corresponding input bit
            assign out[i] = in[rotated_idx];
        end
    endgenerate

endmodule