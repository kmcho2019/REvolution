// 2-to-1 multiplexer module (mux2X1)
module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

// 8-bit barrel shifter module using explicit mux2X1 instances for each bit at each stage
module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,  // ctrl[2]: shift by 4, ctrl[1]: shift by 2, ctrl[0]: shift by 1
    output wire [7:0] out
);
    wire [7:0] stage1;  // After shift-by-4 stage
    wire [7:0] stage2;  // After shift-by-2 stage

    genvar i;

    // Stage 1: Shift by 4 if ctrl[2] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage1_mux
            // Select bit shifted by 4 or original bit
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage2_mux
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage3_mux
            mux2X1 mux_inst (
                .in0(stage2[i]),
                .in1(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule