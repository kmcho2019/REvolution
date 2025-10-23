module TopModule (
    input [2:0] in,
    output [1:0] out
);
    wire [1:0] partial_sum;
    
    // First sum two bits
    assign partial_sum = in[0] + in[1];
    // Then add the third bit
    assign out = partial_sum + in[2];
endmodule