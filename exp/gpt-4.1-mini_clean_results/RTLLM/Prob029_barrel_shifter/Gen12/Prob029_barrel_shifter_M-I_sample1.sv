module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1, stage2;

    localparam SHIFT4 = 4;
    localparam SHIFT2 = 2;
    localparam SHIFT1 = 1;

    // Function to compute (index + shift) modulo 8
    function [2:0] rot_idx;
        input [2:0] idx;
        input [2:0] shift;
        begin
            rot_idx = (idx + shift) % 8;
        end
    endfunction

    genvar i;

    // Stage 1: rotate left by 4 bits if ctrl[2] set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            mux2X1 mux_inst_stage1 (
                .in0(in[i]),
                .in1(in[rot_idx(i[2:0], SHIFT4)]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate left by 2 bits if ctrl[1] set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            mux2X1 mux_inst_stage2 (
                .in0(stage1[i]),
                .in1(stage1[rot_idx(i[2:0], SHIFT2)]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate left by 1 bit if ctrl[0] set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            mux2X1 mux_inst_stage3 (
                .in0(stage2[i]),
                .in1(stage2[rot_idx(i[2:0], SHIFT1)]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule