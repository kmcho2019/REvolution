module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Implement out = a OR b OR c using NOR and NOT gates:
    // out = ~(~a & ~b & ~c)
    wire nor_out;
    assign nor_out = ~(a | b | c); // NOR of inputs
    assign out = ~nor_out;          // NOT of NOR is OR

endmodule