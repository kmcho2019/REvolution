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

    // Intermediate wires for each stage output
    wire [7:0] stage1_out; // After shift by 4 controlled by ctrl[2]
    wire [7:0] stage2_out; // After shift by 2 controlled by ctrl[1]
    wire [7:0] stage3_out; // After shift by 1 controlled by ctrl[0]

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // rotate left by 4: bit i from in[(i+4)%8]
            mux2X1 mux_inst (
                .d0(in[i]),
                .d1(in[(i+4) % 8]),
                .sel(ctrl[2]),
                .y(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            // rotate left by 2: bit i from stage1_out[(i+2)%8]
            mux2X1 mux_inst (
                .d0(stage1_out[i]),
                .d1(stage1_out[(i+2) % 8]),
                .sel(ctrl[1]),
                .y(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            // rotate left by 1: bit i from stage2_out[(i+1)%8]
            mux2X1 mux_inst (
                .d0(stage2_out[i]),
                .d1(stage2_out[(i+1) % 8]),
                .sel(ctrl[0]),
                .y(stage3_out[i])
            );
        end
    endgenerate

    assign out = stage3_out;

endmodule