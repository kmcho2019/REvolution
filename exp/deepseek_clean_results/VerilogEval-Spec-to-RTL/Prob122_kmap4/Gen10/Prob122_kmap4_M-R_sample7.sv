module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire ac_xor = a ^ c;
    wire bd_xor = b ^ d;
    
    assign out = ac_xor ^ bd_xor;

endmodule