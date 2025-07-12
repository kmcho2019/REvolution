module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Calculate out_both
    assign out_both = in & ({1'b0, in[99:1]});

    // Calculate out_any
    assign out_any = in | ({in[98:0], 1'b0});

    // Calculate out_different
    assign out_different = ({in[0], in[99:1]}) ^ in;

endmodule