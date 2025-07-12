module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [2:0] first_one;

    assign first_one = $clog2(in);
    assign pos = (in == 8'b0) ? 3'b000 : first_one;

endmodule