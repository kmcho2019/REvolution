module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Each output bit is selected from rotated input
    // Rotation amount is priority-encoded: 4 > 2 > 1
    wire [2:0] rot_amt = ctrl[2] ? 3'd4 : 
                         ctrl[1] ? 3'd2 : 
                         ctrl[0] ? 3'd1 : 3'd0;

    // Generate 8:1 mux for each output bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: output_mux
            assign out[i] = in[(i + rot_amt) % 8];
        end
    endgenerate

endmodule