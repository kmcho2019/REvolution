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

    wire [7:0] stage1;  // after shift by 4 controlled by ctrl[2]
    wire [7:0] stage2;  // after shift by 2 controlled by ctrl[1]

    genvar i;

    // Stage 1: rotate right by 4 if ctrl[2] == 1, else pass through
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Calculate wrapped index for rotation by 4
            // Equivalent to (i - 4) mod 8:
            // if i >=4 then i-4 else i+4
            wire shifted_bit;
            assign shifted_bit = (i >= 4) ? in[i-4] : in[i+4];

            mux2X1 mux_inst (
                .d0(in[i]),
                .d1(shifted_bit),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate right by 2 if ctrl[1] == 1, else pass through
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Equivalent to (i - 2) mod 8:
            // if i >=2 then i-2 else i+6
            wire shifted_bit;
            assign shifted_bit = (i >= 2) ? stage1[i-2] : stage1[i+6];

            mux2X1 mux_inst (
                .d0(stage1[i]),
                .d1(shifted_bit),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate right by 1 if ctrl[0] == 1, else pass through
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // Equivalent to (i - 1) mod 8:
            // if i >=1 then i-1 else i+7
            wire shifted_bit;
            assign shifted_bit = (i >= 1) ? stage2[i-1] : stage2[i+7];

            mux2X1 mux_inst (
                .d0(stage2[i]),
                .d1(shifted_bit),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule