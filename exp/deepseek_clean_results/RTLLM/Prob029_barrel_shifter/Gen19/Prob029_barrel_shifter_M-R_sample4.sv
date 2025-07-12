module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Intermediate results after each rotation stage
    wire [7:0] after_4bit_rot;
    wire [7:0] after_2bit_rot;
    
    // Stage 1: 4-bit right rotation (controlled by ctrl[2])
    assign after_4bit_rot = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: 2-bit right rotation (controlled by ctrl[1])
    assign after_2bit_rot = ctrl[1] ? {after_4bit_rot[1:0], after_4bit_rot[7:2]} : after_4bit_rot;
    
    // Stage 3: 1-bit right rotation (controlled by ctrl[0])
    assign out = ctrl[0] ? {after_2bit_rot[0], after_2bit_rot[7:1]} : after_2bit_rot;
endmodule