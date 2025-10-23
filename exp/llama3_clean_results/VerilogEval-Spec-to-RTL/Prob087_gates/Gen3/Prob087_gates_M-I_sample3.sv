module TopModule(
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

// Directly assign outputs for simpler operations
assign out_and = a & b;
assign out_or = a | b;
assign out_anotb = a & ~b;

// Use intermediate variables for operations that benefit from clarity
wire xor_result = a ^ b;
assign out_xor = xor_result;
assign out_nand = ~(a & b);
assign out_nor = ~(a | b);
assign out_xnor = ~(a ^ b);

endmodule