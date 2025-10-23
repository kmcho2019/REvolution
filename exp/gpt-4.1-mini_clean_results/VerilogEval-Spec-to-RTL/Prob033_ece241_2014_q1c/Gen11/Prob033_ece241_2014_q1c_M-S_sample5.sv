module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;
    
    // Extend inputs to signed 9-bit for sum calculation to detect carry out
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];
    
    // Overflow detection: when sign of inputs are the same but differ from sum sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule