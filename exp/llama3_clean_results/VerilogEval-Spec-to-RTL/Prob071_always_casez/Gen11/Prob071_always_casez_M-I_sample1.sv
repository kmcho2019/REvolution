module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    // Using $clog2 to find the position of the first '1' bit
    assign pos = in ? $clog2(in) : 3'd0;

endmodule