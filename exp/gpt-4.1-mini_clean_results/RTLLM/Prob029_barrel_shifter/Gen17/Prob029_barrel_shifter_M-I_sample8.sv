module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Rotate left function for 8-bit vector with parameterized shift amount
    // Will be used to generate shifted versions efficiently
    function [7:0] rotate_left;
        input [7:0] val;
        input integer shift_amt;
        begin
            rotate_left = {val, val} << shift_amt;
            rotate_left = rotate_left[15:8];
        end
    endfunction

    // Stage 1 shift by 4 if ctrl[2]
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2 shift by 2 if ctrl[1]
    wire [7:0] stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;

    // Stage 3 shift by 1 if ctrl[0]
    assign out = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

endmodule