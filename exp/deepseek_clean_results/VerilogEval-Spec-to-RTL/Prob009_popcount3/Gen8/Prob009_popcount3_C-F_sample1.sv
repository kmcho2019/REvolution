module TopModule #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] in,
    output [1:0] out
);

    // Population count (number of 1's) for 3-bit input
    // Optimized implementation using:
    // - XOR for LSB (odd parity)
    // - Majority function for MSB (two or more 1's)
    // Single-level logic for minimal delay
    assign out[0] = in[0] ^ in[1] ^ in[2];          // LSB: sum mod 2
    assign out[1] = (in[0] & in[1]) |               // Majority of 3
                   (in[1] & in[2]) | 
                   (in[0] & in[2]);

endmodule