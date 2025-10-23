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

    // Parameterized gate functions
    function automatic bit AND(input bit x, y);
        return x & y;
    endfunction

    function automatic bit OR(input bit x, y);
        return x | y;
    endfunction

    function automatic bit XOR(input bit x, y);
        return x ^ y;
    endfunction

    // Compute all outputs using gate functions
    assign out_and   = AND(a, b);
    assign out_or    = OR(a, b);
    assign out_xor   = XOR(a, b);
    assign out_nand  = ~AND(a, b);
    assign out_nor   = ~OR(a, b);
    assign out_xnor  = ~XOR(a, b);
    assign out_anotb = a & (~b);  // Efficient bit-mask implementation

endmodule