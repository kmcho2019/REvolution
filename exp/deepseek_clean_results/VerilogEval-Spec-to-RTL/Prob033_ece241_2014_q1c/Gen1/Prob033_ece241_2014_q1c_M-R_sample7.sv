module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [7:0] sum;
    wire carry_in, carry_out;

    // Perform 8-bit addition directly
    assign {carry_out, sum} = a + b;
    
    // Calculate carry into MSB (sign bit)
    assign carry_in = a[6] & b[6] | a[6] & carry_out | b[6] & carry_out;
    
    // Overflow occurs when carry_in != carry_out for sign bit
    assign overflow = carry_in ^ carry_out;
    
    // Final sum output
    assign s = sum;

endmodule