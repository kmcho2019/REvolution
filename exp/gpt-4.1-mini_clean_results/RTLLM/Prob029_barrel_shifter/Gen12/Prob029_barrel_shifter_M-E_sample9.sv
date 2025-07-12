module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Compute rotation amount as ctrl[0]*1 + ctrl[1]*2 + ctrl[2]*4
    wire [2:0] rotate_amt;
    assign rotate_amt = {ctrl[2], ctrl[1], ctrl[0]};

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rot_bits
            // Calculate rotated index: (i + rotate_amt) modulo 8
            // Use nested mux2X1 to select the bit based on rotate_amt bits

            // Level 0 mux: select between bit i and bit i+1 (if ctrl[0])
            wire l0_0, l0_1;
            mux2X1 mux_l0_0 (.d0(in[(i+0) & 3'b111]), .d1(in[(i+1) & 3'b111]), .sel(ctrl[0]), .y(l0_0));
            mux2X1 mux_l0_1 (.d0(in[(i+2) & 3'b111]), .d1(in[(i+3) & 3'b111]), .sel(ctrl[0]), .y(l0_1));

            // Level 1 mux: select between level0 outputs based on ctrl[1]
            wire l1;
            mux2X1 mux_l1 (.d0(l0_0), .d1(l0_1), .sel(ctrl[1]), .y(l1));

            // Level 2 mux: select between l1 and l1 shifted by 4 bits (rotated by 4)
            // For rotate by 4, bits wrap around by adding 4 modulo 8:
            // We calculate similar for (i + 4 + rotate_amt modulo 8)
            // But since rotation amount is decomposed in bits, 
            // At this level, select between the current l1 and l1 shifted by 4.

            // Create corresponding signals shifted by 4:
            wire l0_0_4, l0_1_4;
            mux2X1 mux_l0_0_4 (.d0(in[(i+4) & 3'b111]), .d1(in[(i+5) & 3'b111]), .sel(ctrl[0]), .y(l0_0_4));
            mux2X1 mux_l0_1_4 (.d0(in[(i+6) & 3'b111]), .d1(in[(i+7) & 3'b111]), .sel(ctrl[0]), .y(l0_1_4));

            wire l1_4;
            mux2X1 mux_l1_4 (.d0(l0_0_4), .d1(l0_1_4), .sel(ctrl[1]), .y(l1_4));

            mux2X1 mux_l2 (.d0(l1), .d1(l1_4), .sel(ctrl[2]), .y(out[i]));

        end
    endgenerate

endmodule