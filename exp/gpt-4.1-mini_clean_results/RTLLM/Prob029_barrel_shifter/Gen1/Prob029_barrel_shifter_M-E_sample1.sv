module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Rotate left by ctrl (0 to 7)
    // For each output bit position i,
    // out[i] = in[(i + ctrl) mod 8]

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotate_left
            assign out[i] = in[(i + ctrl) % 8];
        end
    endgenerate

endmodule