module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire carry_out;
    
    // Perform the addition and capture the carry-out
    assign {carry_out, s} = a + b;
    
    // Optimized overflow detection using carry-in/out method
    assign overflow = (a[7] ^ b[7]) ? 1'b0 : (a[7] ^ s[7]);
endmodule