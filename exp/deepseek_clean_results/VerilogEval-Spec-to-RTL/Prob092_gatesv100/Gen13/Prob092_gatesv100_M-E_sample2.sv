module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular left-shifted version of input (for wrap-around)
    wire [99:0] shifted_in = {in[0], in[99:1]};

    // out_both: current AND left-shifted (MSB=0)
    assign out_both = {1'b0, in[98:0] & shifted_in[98:0]};

    // out_any: current OR right-shifted (LSB=0)
    assign out_any = {shifted_in[99:1] | in[99:1], 1'b0};

    // out_different: current XOR circular-shifted
    assign out_different = in ^ shifted_in;

endmodule