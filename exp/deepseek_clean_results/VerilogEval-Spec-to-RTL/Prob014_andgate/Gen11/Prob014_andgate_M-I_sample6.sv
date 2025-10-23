// Behavioral implementation (original optimal solution)
module TopModule(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

// Alternative structural implementation
/*
module TopModule(
    input a,
    input b,
    output out
);
    and g1(out, a, b);  // Using Verilog primitive
endmodule
*/