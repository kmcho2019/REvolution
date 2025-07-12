module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct combinational assignment of out as a OR b OR c
    assign out = a | b | c;

endmodule