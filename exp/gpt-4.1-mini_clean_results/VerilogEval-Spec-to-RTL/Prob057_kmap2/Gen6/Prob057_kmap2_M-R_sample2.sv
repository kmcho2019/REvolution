module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = ((!c) && (!b)) || ((!d) && (!a)) || (c && d && (a || b));

endmodule