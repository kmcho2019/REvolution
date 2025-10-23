module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Explicit wire declarations for each stage
    wire [7:0] after_4bit_shift;
    wire [7:0] after_2bit_shift;
    wire [7:0] after_1bit_shift;

    // Stage 1: 4-bit right rotation
    assign after_4bit_shift = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: 2-bit right rotation
    assign after_2bit_shift = ctrl[1] ? {after_4bit_shift[1:0], after_4bit_shift[7:2]} : after_4bit_shift;

    // Stage 3: 1-bit right rotation
    assign after_1bit_shift = ctrl[0] ? {after_2bit_shift[0], after_2bit_shift[7:1]} : after_2bit_shift;

    // Final output assignment
    assign out = after_1bit_shift;
endmodule