module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND operation using reduction operator
    assign out_and = &in;
    
    // OR operation using reduction operator
    assign out_or  = |in;
    
    // XOR operation (parity calculation)
    assign out_xor = ^in;

endmodule