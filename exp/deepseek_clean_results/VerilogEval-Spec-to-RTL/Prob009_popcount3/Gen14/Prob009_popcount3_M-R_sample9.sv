module TopModule (
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] lower_bits_count;
    
    // Count '1's in lower 2 bits
    assign lower_bits_count = in[0] + in[1];
    
    // Add the MSB to get final count
    assign out = lower_bits_count + in[2];

endmodule