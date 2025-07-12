module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    wire and_result, or_result, xor_result;
    
    assign and_result = a & b;
    assign or_result = a | b;
    assign xor_result = a ^ b;

    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;
    assign out_nand = ~and_result;
    assign out_nor = ~or_result;
    assign out_xnor = ~xor_result;
    assign out_anotb = a & (~b);

endmodule