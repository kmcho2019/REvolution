module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Implement AND gate using continuous assignment
assign out_assign = a & b;

// Implement AND gate using combinational always block
always @(*)
    out_alwaysblock = a & b;

endmodule