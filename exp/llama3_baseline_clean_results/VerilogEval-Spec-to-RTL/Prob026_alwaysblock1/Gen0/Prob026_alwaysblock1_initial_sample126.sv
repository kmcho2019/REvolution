module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

// Using assign statement for AND operation
assign out_assign = a & b;

// Using always block for AND operation
always @(*)
    out_alwaysblock = a & b;

endmodule