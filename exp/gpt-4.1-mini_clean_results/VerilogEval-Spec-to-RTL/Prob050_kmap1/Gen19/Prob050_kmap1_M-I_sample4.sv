// Optional structural definition using a single 3-input OR gate primitive (for some synthesis tools):
/*
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    or3 U_or3 (.out(out), .in1(a), .in2(b), .in3(c)); // Example primitive gate, may vary by tool
endmodule
*/

// Minimal and optimal implementation using continuous assignment
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    assign out = a | b | c;
endmodule