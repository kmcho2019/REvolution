module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Calculate out_both: Each bit indicates if both it and its left neighbour are '1'.
    assign out_both = in & ({in[99:1], 1'b0});

    // Calculate out_any: Each bit indicates if it or its right neighbour is '1'.
    assign out_any = in | ({1'b0, in[99:1]});

    // Calculate out_different: Each bit indicates if it is different from its left neighbour (wrapping around).
    assign out_different = in ^ ({in[0], in[99:1]});

endmodule