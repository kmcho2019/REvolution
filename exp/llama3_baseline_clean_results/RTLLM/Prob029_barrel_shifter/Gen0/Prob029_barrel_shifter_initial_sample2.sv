// Define the mux2X1 submodule
module mux2X1(out, in0, in1, sel);
    output [7:0] out;
    input [7:0] in0, in1;
    input sel;
    
    reg [7:0] out_reg;
    
    always @(in0, in1, sel)
    begin
        if (sel)
            out_reg = in1;
        else
            out_reg = in0;
    end
    
    assign out = out_reg;
endmodule

// Define the barrel_shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;
    
    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_in0, stage1_in1;
    assign stage1_in0 = in;
    assign stage1_in1 = {in[3:0], 4'b0000};
    
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(stage1_out, stage1_in0, stage1_in1, ctrl[2]);
    
    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_in0, stage2_in1;
    assign stage2_in0 = stage1_out;
    assign stage2_in1 = {stage1_out[5:0], 2'b00};
    
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(stage2_out, stage2_in0, stage2_in1, ctrl[1]);
    
    // Stage 3: Shift by 1 position
    wire [7:0] stage3_in0, stage3_in1;
    assign stage3_in0 = stage2_out;
    assign stage3_in1 = {stage2_out[6:0], 1'b0};
    
    mux2X1 stage3_mux(out, stage3_in0, stage3_in1, ctrl[0]);
endmodule