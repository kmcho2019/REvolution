module TopModule (
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

    // Base operations
    wire and_result = a & b;
    wire or_result  = a | b;
    wire xor_result = a ^ b;

    // Output assignments
    assign out_and   = and_result;  // a AND b
    assign out_nand  = ~and_result; // NOT (a AND b)
    
    assign out_or    = or_result;   // a OR b
    assign out_nor   = ~or_result;  // NOT (a OR b)
    
    assign out_xor   = xor_result;  // a XOR b
    assign out_xnor  = ~xor_result; // NOT (a XOR b)
    
    assign out_anotb = a & ~b;      // a AND NOT b

endmodule