module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire all_zero = ~(a | b | c | d);
    wire all_one = a & b & c & d;
    wire odd_parity = a ^ b ^ c ^ d;
    
    assign q = all_zero ? 1'b1 : 
               all_one ? 1'b1 :
               (a&b | a&c | a&d | b&c | b&d | c&d) ? odd_parity : 1'b0;

endmodule