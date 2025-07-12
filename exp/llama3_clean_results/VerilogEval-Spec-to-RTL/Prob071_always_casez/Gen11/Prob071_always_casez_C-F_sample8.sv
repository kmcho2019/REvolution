module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    assign pos = $clog2(in);

endmodule