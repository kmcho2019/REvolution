module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire ac;
    wire ad;
    wire bc;
    wire bd;

    assign ac = a & c;
    assign ad = a & d;
    assign bc = b & c;
    assign bd = b & d;

    assign q = ac | ad | bc | bd;

endmodule