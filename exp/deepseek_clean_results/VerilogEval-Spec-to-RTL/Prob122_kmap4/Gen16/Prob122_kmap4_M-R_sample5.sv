module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire ab_xor;
    wire abc_xor;
    
    assign ab_xor = a ^ b;
    assign abc_xor = ab_xor ^ c;
    assign out = abc_xor ^ d;
endmodule