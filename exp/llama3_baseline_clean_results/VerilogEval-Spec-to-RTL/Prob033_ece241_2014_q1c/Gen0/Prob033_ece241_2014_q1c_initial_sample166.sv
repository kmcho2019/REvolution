module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output      overflow
);

    assign {overflow, s} = $signed(a) + $signed(b);

endmodule