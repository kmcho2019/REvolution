// Define the mux2X1 submodule
module mux2X1(out, a, b, sel);
    output out;
    input a, b, sel;
    
    assign out = (sel) ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;
    
    wire [7:0] stage1_out, stage2_out, stage3_out;
    
    // Stage 1: Shift by 4 positions if ctrl[2] is high
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            mux2X1 stage1_mux(out[i], in[i], (i < 4) ? in[i + 4] : 8'b0, ctrl[2]);
        end
    endgenerate
    
    // Store the result of stage1 in stage1_out
    assign stage1_out = out;
    
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin
            mux2X1 stage2_mux(out[i], stage1_out[i], (i < 6) ? stage1_out[i + 2] : (i == 6) ? stage1_out[0] : stage1_out[1], ctrl[1]);
        end
    endgenerate
    
    // Store the result of stage2 in stage2_out
    assign stage2_out = out;
    
    // Stage 3: Shift by 1 position if ctrl[0] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin
            mux2X1 stage3_mux(out[i], stage2_out[i], (i < 7) ? stage2_out[i + 1] : stage2_out[0], ctrl[0]);
        end
    endgenerate
    
    // Final output
    assign out = stage3_out;
    
    // Handle the final rotation and assignment
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign stage3_out[i] = out[i];
        end
    endgenerate
endmodule