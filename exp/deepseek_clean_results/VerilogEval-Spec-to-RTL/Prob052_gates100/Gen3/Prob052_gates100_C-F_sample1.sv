module TopModule #(
    parameter WIDTH = 100
) (
    input [WIDTH-1:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 100-input AND: 1 only if all bits are 1
    assign out_and = &in;
    
    // 100-input OR: 1 if any bit is 1
    assign out_or  = |in;
    
    // 100-input XOR: 1 if odd number of bits are 1 (parity)
    assign out_xor = ^in;

endmodule