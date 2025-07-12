// 2-to-1 multiplexer module
module mux2X1(
    input   logic       sel,
    input   logic [7:0]  in0,
    input   logic [7:0]  in1,
    output  logic [7:0]  out
);
    always_comb begin
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule

// Barrel shifter module
module barrel_shifter(
    input   logic [7:0]  in,
    input   logic [2:0]  ctrl,
    output  logic [7:0]  out
);

    logic [7:0]  stage1_out;
    logic [7:0]  stage2_out;
    logic [7:0]  stage3_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux(
        .sel(ctrl[2]),
        .in0(in),  // Original input
        .in1({in[3:0], 4'b0000}),  // Input shifted by 4 positions
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux(
        .sel(ctrl[1]),
        .in0(stage1_out),  // Output from previous stage
        .in1({stage1_out[5:0], 2'b00}),  // Output shifted by 2 positions
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux(
        .sel(ctrl[0]),
        .in0(stage2_out),  // Output from previous stage
        .in1({stage2_out[6:0], 1'b0}),  // Output shifted by 1 position
        .out(stage3_out)
    );

    // Final output
    assign out = stage3_out;
endmodule