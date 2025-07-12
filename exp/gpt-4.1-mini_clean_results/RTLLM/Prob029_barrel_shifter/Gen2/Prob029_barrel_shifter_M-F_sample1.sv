// 2-to-1 multiplexer module: selects out = sel ? in1 : in0
module mux2X1 (
    input wire in0,
    input wire in1,
    input wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

// 8-bit rotating barrel shifter module using mux2X1 modules
module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1; // after 4-bit rotation if ctrl[2]
    wire [7:0] stage2; // after 2-bit rotation if ctrl[1]
    
    genvar i;

    // Stage 1: rotate right by 4 bits if ctrl[2]==1
    // For each bit i:
    //   shifted bit = in[(i+4) mod 8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            mux2X1 mux_inst (
                .in0(in[i]),
                .in1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate right by 2 bits if ctrl[1]==1
    // For each bit i:
    //   shifted bit = stage1[(i+2) mod 8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            mux2X1 mux_inst (
                .in0(stage1[i]),
                .in1(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate right by 1 bit if ctrl[0]==1
    // For each bit i:
    //   shifted bit = stage2[(i+1) mod 8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            mux2X1 mux_inst (
                .in0(stage2[i]),
                .in1(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule