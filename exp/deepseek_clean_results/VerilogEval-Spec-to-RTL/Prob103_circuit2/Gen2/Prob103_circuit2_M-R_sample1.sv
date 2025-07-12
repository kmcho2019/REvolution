module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire parity = a ^ b ^ c ^ d;
    wire all_zeros = ~(a | b | c | d);
    
    assign q = (all_zeros) ? 1'b1 : parity;

endmodule