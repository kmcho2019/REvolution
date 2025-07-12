module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

    // 2-to-1 multiplexer: output 'a' when sel=0, output 'b' when sel=1
    assign out = sel ? b : a;

endmodule