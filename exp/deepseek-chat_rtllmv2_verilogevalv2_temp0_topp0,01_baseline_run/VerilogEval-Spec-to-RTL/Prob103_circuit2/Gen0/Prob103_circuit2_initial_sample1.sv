module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire parity = a ^ b ^ c ^ d;
    wire all_zero = ~a & ~b & ~c & ~d;
    wire all_one = a & b & c & d;
    
    assign q = ~(parity ^ (all_zero | all_one));
endmodule