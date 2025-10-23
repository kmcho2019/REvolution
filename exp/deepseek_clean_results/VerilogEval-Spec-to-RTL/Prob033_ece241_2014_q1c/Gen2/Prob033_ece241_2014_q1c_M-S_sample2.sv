module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_ext;
    
    // Perform 9-bit addition to capture carry out
    assign sum_ext = {a[7], a} + {b[7], b};
    
    // Extract 8-bit result
    assign s = sum_ext[7:0];
    
    // Overflow occurs when carry-in ≠ carry-out for MSB
    assign overflow = sum_ext[8] ^ sum_ext[7];
endmodule