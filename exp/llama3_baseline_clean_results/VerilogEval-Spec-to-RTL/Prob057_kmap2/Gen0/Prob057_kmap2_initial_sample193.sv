module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a == d) && !b && !c ? 1'b0 :
             (a == d) && (b || c) ? 1'b1 :
             (a != d) && (b && c) ? 1'b0 :
             (a != d) && (!b || !c) ? 1'b1 : 1'b0;

endmodule