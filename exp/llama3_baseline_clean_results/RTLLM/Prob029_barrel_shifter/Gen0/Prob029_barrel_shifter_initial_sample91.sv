// mux2X1 submodule to select between two inputs based on the sel signal
module mux2X1(
    input  wire    sel,
    input  wire    in0,
    input  wire    in1,
    output wire    out
);

    assign out = (sel)? in1 : in0;

endmodule

// barrel_shifter module
module barrel_shifter(
    input  wire [7:0]  in,
    input  wire [2:0]  ctrl,
    output wire [7:0]  out
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: stage1_gen
            mux2X1 stage1_mux(
               .sel(ctrl[2]),
               .in0(in[i]),
               .in1((i < 4)? in[i + 4] : 1'b0),
               .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    generate
        for (i = 0; i < 8; i = i + 1) begin: stage2_gen
            mux2X1 stage2_mux(
               .sel(ctrl[1]),
               .in0(stage1_out[i]),
               .in1((i < 6)? stage1_out[i + 2] : 1'b0),
               .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_out;
    generate
        for (i = 0; i < 8; i = i + 1) begin: stage3_gen
            mux2X1 stage3_mux(
               .sel(ctrl[0]),
               .in0(stage2_out[i]),
               .in1((i < 7)? stage2_out[i + 1] : 1'b0),
               .out(stage3_out[i])
            );
        end
    endgenerate

    // Assign final output
    assign out = stage3_out;

endmodule