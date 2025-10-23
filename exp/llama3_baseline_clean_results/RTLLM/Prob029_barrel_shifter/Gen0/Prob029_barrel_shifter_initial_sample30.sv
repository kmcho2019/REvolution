// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    always @(a, b, sel)
    begin
        if (sel == 1'b1)
            out = b;
        else
            out = a;
    end
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    reg [7:0] stage1_out;
    always @(in, ctrl[2])
    begin
        if (ctrl[2] == 1'b1)
            stage1_out = {in[3:0], in[7:4]};
        else
            stage1_out = in;
    end

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    reg [7:0] stage2_out;
    always @(stage1_out, ctrl[1])
    begin
        if (ctrl[1] == 1'b1)
            stage2_out = {stage1_out[5:0], stage1_out[7:6]};
        else
            stage2_out = stage1_out;
    end

    // Stage 3: Shift by 1 position if ctrl[0] is high
    always @(stage2_out, ctrl[0])
    begin
        if (ctrl[0] == 1'b1)
            out = {stage2_out[6:0], stage2_out[7]};
        else
            out = stage2_out;
    end
endmodule