module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Continuous assignment for AND operation
    assign out = a & b;
endmodule