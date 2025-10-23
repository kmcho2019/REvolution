module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized population count combining best aspects of both examples
    wire sum_lsb = in[0] ^ in[1] ^ in[2];  // Direct XOR for LSB
    wire sum_msb = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);  // Majority function for MSB
    
    assign out = {sum_msb, sum_lsb};
endmodule