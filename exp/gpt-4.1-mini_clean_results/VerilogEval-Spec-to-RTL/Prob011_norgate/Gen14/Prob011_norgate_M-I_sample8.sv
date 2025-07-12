module TopModule (
    input  a,
    input  b,
    output out
);
    // Using continuous assignment with bitwise NOR operator for concise and clear implementation
    assign out = ~(a | b);
endmodule