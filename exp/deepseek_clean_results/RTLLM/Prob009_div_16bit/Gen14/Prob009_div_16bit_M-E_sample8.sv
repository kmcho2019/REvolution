module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [16:0] partial_remainder; // 17 bits to handle overflow
    integer i;

    always @(*) begin
        partial_remainder = {1'b0, A}; // Initialize with dividend
        result = 16'b0;                // Initialize quotient
        
        // Binary search division
        for (i = 15; i >= 0; i = i - 1) begin
            // Check if we can subtract (B << i) from remainder
            if (partial_remainder >= ({9'b0, B} << i)) begin
                partial_remainder = partial_remainder - ({9'b0, B} << i);
                result[i] = 1'b1; // Set corresponding quotient bit
            end
        end
        
        // Final remainder (only need 8 bits, but output is 16 bits)
        odd = {8'b0, partial_remainder[7:0]};
    end

endmodule