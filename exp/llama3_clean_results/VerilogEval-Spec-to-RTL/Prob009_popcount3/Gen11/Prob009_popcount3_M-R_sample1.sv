// Module to count the number of '1's in a 3-bit input vector
module TopModule(
    input [2:0] in,  // 3-bit input vector
    output reg [1:0] out // 2-bit output vector to hold the count
);

    // Use an always block to compute the sum of the input bits
    always @(*) begin
        // Initialize the output to 0 (not necessary but for clarity)
        out = 0;
        
        // Count the number of '1's in the input vector
        out = in[0] + in[1] + in[2];
    end

endmodule