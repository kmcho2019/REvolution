// Define the mux2X1 submodule
module mux2X1(
    input   logic       sel,
    input   logic [7:0]  in0,
    input   logic [7:0]  in1,
    output  logic [7:0]  out
);

    always_comb begin
        case(sel)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = 8'b0;
        endcase
    end

endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input   logic [7:0]  in,
    input   logic [2:0]  ctrl,
    output  logic [7:0]  out
);

    // Stage 1: Shift by 4 positions
    logic [7:0]  stage1_in0, stage1_in1;
    assign stage1_in0 = in;
    assign stage1_in1 = {in[3:0], in[7:4]};
    logic [7:0]  stage1_out;
    mux2X1 stage1_mux(.sel(ctrl[2]),.in0(stage1_in0),.in1(stage1_in1),.out(stage1_out));

    // Stage 2: Shift by 2 positions
    logic [7:0]  stage2_in0, stage2_in1;
    assign stage2_in0 = stage1_out;
    assign stage2_in1 = {stage1_out[5:0], stage1_out[7:6]};
    logic [7:0]  stage2_out;
    mux2X1 stage2_mux(.sel(ctrl[1]),.in0(stage2_in0),.in1(stage2_in1),.out(stage2_out));

    // Stage 3: Shift by 1 position
    logic [7:0]  stage3_in0, stage3_in1;
    assign stage3_in0 = stage2_out;
    assign stage3_in1 = {stage2_out[6:0], stage2_out[7]};
    assign out = stage3_in0;
    mux2X1 stage3_mux(.sel(ctrl[0]),.in0(stage3_in0),.in1(stage3_in1),.out(out));

endmodule