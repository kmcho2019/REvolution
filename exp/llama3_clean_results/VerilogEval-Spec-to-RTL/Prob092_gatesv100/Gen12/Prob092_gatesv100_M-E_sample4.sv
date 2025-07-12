module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create a circularly shifted version of in for out_different
    wire [99:0] in_circular = {in[99], in[99:1]};

    // Calculate out_both by comparing each bit with its left neighbor
    assign out_both = in & {1'b0, in[99:1]};

    // Calculate out_any by comparing each bit with its right neighbor
    assign out_any = {in[0], in[99:1]} | in;

    // Calculate out_different by comparing each bit with its left neighbor in a circular manner
    assign out_different = in ^ in_circular;

endmodule