module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Directly implement the required logic
    assign out = (a & b) | (c & d);
    // Implement the inverter directly for the inverted output
    assign out_n = ~out;
endmodule