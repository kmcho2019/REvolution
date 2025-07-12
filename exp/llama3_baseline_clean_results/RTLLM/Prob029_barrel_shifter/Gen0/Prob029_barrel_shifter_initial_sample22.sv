// Define the mux2X1 submodule
module mux2X1(
    input  [7:0] a, b,
    input         sel,
    output [7:0] out
);
    always @(a, b, sel) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0;
        endcase
    end
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);
    // First stage: Shift by 4 positions
    wire [7:0] shift4;
    assign shift4 = {in[3:0], in[7:4]};
    
    // First stage multiplexer
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(in, shift4, ctrl[2], stage1_out);

    // Second stage: Shift by 2 positions
    wire [7:0] shift2;
    assign shift2 = {stage1_out[5:0], stage1_out[7:6]};
    
    // Second stage multiplexer
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(stage1_out, shift2, ctrl[1], stage2_out);

    // Third stage: Shift by 1 position
    wire [7:0] shift1;
    assign shift1 = {stage2_out[6:0], stage2_out[7]};
    
    // Third stage multiplexer
    mux2X1 stage3_mux(stage2_out, shift1, ctrl[0], out);
endmodule