module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Calculate the sum of a and b using a 9-bit temporary variable to check for overflow
    wire [8:0] sum = {a[7], a} + {b[7], b};
    
    // The overflow occurs when the MSB of the sum is different from the MSB of the input numbers
    assign overflow = sum[8] != sum[7];
    
    // The final result s is the 8 least significant bits of the sum
    assign s = sum[7:0];

endmodule