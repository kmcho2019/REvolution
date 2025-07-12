module TopModule (
    input a,
    input b,
    output out
);
    assign out = nor(a, b);
endmodule