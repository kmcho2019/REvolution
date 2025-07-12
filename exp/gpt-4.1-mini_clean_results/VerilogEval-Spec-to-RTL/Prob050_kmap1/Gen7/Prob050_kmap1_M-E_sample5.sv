module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire nor_out;

    // NOR gate on all inputs
    assign nor_out = ~(a | b | c);

    // Invert the NOR output to get OR function
    assign out = ~nor_out;

endmodule