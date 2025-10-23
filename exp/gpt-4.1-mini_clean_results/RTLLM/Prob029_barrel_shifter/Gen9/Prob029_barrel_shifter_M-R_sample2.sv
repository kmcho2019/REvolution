module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Calculate total shift amount based on ctrl bits
    // ctrl[2] adds 4, ctrl[1] adds 2, ctrl[0] adds 1
    wire [2:0] shift_amt = (ctrl[2] ? 3'd4 : 3'd0) +
                           (ctrl[1] ? 3'd2 : 3'd0) +
                           (ctrl[0] ? 3'd1 : 3'd0);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotate_bits
            // Rotate left by shift_amt
            assign out[i] = in[(i + shift_amt) & 3'h7];
        end
    endgenerate

endmodule