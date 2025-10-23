// Define the mux2X1 submodule
module mux2X1(in0, in1, sel, out);
    input in0, in1, sel;
    output out;
    reg out;
    
    always @(in0, in1, sel)
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    reg [7:0] out;
    reg [7:0] stage1_out;
    reg [7:0] stage2_out;
    reg [7:0] stage3_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    always @(in, ctrl)
        for (int i = 0; i < 8; i++) begin
            if (ctrl[2] == 1'b1)
                if (i < 4)
                    stage1_out[i] = in[i+4];
                else
                    stage1_out[i] = in[i-4];
            else
                stage1_out[i] = in[i];
        end

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    always @(stage1_out, ctrl)
        for (int i = 0; i < 8; i++) begin
            if (ctrl[1] == 1'b1)
                if (i < 6)
                    stage2_out[i] = stage1_out[i+2];
                else
                    stage2_out[i] = stage1_out[i-2];
            else
                stage2_out[i] = stage1_out[i];
        end

    // Stage 3: Shift by 1 position if ctrl[0] is high
    always @(stage2_out, ctrl)
        for (int i = 0; i < 8; i++) begin
            if (ctrl[0] == 1'b1)
                if (i < 7)
                    stage3_out[i] = stage2_out[i+1];
                else
                    stage3_out[i] = stage2_out[i-1];
            else
                stage3_out[i] = stage2_out[i];
        end

    // Assign the final output
    always @(stage3_out)
        out = stage3_out;
endmodule