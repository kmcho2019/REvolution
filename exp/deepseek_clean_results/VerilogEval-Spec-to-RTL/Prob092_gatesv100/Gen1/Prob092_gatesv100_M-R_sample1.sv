module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND each bit with its left neighbor (right-shifted version)
    assign out_both = {1'b0, in[99:1]} & in;

    // out_any: OR each bit with its right neighbor (left-shifted version)
    assign out_any = {in[98:0], 1'b0} | in;

    // out_different: XOR each bit with its left neighbor (with wrap-around)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule