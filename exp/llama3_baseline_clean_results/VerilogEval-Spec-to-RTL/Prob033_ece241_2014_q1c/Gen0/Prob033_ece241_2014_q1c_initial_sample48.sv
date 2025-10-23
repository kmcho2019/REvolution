module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output      overflow
);

    assign s = $signed(a) + $signed(b);
    assign overflow = ($signed(a)[7] == $signed(b)[7] && $signed(a)[7] != s[7]);

endmodule