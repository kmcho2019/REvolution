module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Continuous assignment for AND operation
assign out_assign = a & b;

// Combinational always block for AND operation
always @(*)
    out_alwaysblock = a & b;

endmodule