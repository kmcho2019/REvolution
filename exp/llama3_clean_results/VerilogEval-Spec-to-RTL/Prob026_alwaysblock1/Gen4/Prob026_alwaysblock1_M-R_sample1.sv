// Refactored Version 1: Simplified Hierarchy
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

assign out_assign = a & b;

always @(*) out_alwaysblock = a & b;

endmodule

// Refactored Version 2: Consistent Syntax
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b;
assign out_alwaysblock = a & b;

endmodule