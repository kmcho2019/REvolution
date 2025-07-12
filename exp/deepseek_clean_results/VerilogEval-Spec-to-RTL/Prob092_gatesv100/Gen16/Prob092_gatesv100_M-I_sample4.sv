module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create shifted versions of input for neighbor comparisons
    wire [99:0] in_left = {in[98:0], 1'b0};  // Shift left with zero fill
    wire [99:0] in_right = {1'b0, in[99:1]}; // Shift right with zero fill
    wire [99:0] in_wrapped = {in[0], in[99:1]}; // Circular shift for wrap-around

    // out_both: current AND left neighbor (MSB gets 0)
    assign out_both = in & in_left;

    // out_any: current OR right neighbor (LSB gets 0)
    assign out_any = in | in_right;

    // out_different: current XOR left neighbor (with wrap-around)
    assign out_different = in ^ in_wrapped;

endmodule