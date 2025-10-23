module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Output is high if any input is high, else low
    assign out = a | b | c;

endmodule