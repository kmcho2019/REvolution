module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] shifted_left;
    wire [3:0] shifted_right;

    assign shifted_left = {in[2:0], in[3]}; // Shift left and wrap around
    assign shifted_right = {in[1:3], in[0]}; // Shift right and wrap around

    assign out_both[3:0] = in & shifted_left;
    assign out_any[3:0] = in | shifted_right;
    assign out_different[3:0] = ~(in ^ shifted_left);

endmodule