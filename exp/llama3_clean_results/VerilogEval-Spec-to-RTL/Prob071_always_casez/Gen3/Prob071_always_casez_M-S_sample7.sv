module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    assign pos = $clog2(in) - 1;

endmodule