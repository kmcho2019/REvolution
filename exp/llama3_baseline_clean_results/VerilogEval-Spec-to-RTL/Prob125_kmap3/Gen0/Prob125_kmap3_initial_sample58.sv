module TopModule (
    input a,
    input b,
    input c,
    input d, // Don't care
    output out
);

assign out = (c) || (!a && !b) || (a && !b);

endmodule