module barrel_shifter(
    input   [7:0] in,
    input   [2:0] ctrl,
    output  [7:0] out
);

// Define the mux2X1 submodule
module mux2X1(
    input   [7:0] in0,
    input   [7:0] in1,
    input         sel,
    output  [7:0] out
);
    always @(*) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule

// First stage: shift by 4 positions if ctrl[2] is high
wire [7:0] stage1_in0, stage1_in1, stage1_out;
assign stage1_in0 = in;
assign stage1_in1 = {in[3:0], 4'b0000};
mux2X1 stage1_mux(stage1_in0, stage1_in1, ctrl[2], stage1_out);

// Second stage: shift by 2 positions if ctrl[1] is high
wire [7:0] stage2_in0, stage2_in1, stage2_out;
assign stage2_in0 = stage1_out;
assign stage2_in1 = {stage1_out[5:0], 2'b00};
mux2X1 stage2_mux(stage2_in0, stage2_in1, ctrl[1], stage2_out);

// Third stage: shift by 1 position if ctrl[0] is high
wire [7:0] stage3_in0, stage3_in1, stage3_out;
assign stage3_in0 = stage2_out;
assign stage3_in1 = {stage2_out[6:0], 1'b0};
mux2X1 stage3_mux(stage3_in0, stage3_in1, ctrl[0], stage3_out);

// Assign the final output
assign out = stage3_out;

endmodule