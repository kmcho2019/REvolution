module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    assign and_out1 = (a && b)? 1'b1 : 1'b0;
    assign and_out2 = (c && d)? 1'b1 : 1'b0;
    assign out = (and_out1 || and_out2)? 1'b1 : 1'b0;
    assign out_n = ~out;
endmodule