module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Calculate total shift amount from ctrl bits (1, 2, 4)
    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotate_loop
            // Rotate left by shift_amount bits with wrap-around
            assign out[i] = in[(i + shift_amount) & 3'b111];
        end
    endgenerate

endmodule