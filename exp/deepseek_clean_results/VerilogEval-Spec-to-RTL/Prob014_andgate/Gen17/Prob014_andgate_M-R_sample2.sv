module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Using Verilog built-in AND primitive
    and g1(out, a, b);
endmodule