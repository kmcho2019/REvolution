module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create circular left-shifted version (in[0] moves to [99], others shift left)
    wire [99:0] left_neighbor = {in[0], in[99:1]};

    // out_both: current AND left neighbor, with MSB forced to 0
    assign out_both = (in & left_neighbor) & {1'b0, {99{1'b1}}};

    // out_any: current OR right neighbor (which is left_neighbor of next bit)
    // Create right neighbor by circular right shift
    wire [99:0] right_neighbor = {in[98:0], in[99]};
    assign out_any = (in | right_neighbor) & {{99{1'b1}}, 1'b0};

    // out_different: current XOR left neighbor (wrap-around already handled)
    assign out_different = in ^ left_neighbor;

endmodule