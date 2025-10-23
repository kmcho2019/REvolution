module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    assign pos = (in == 8'b0)? 3'd0 : $clog2(in);

endmodule