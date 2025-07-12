module multi_8bit (
    input clk,          // Clock for sequential operation
    input start,        // Start signal
    input [7:0] A,      // Multiplicand
    input [7:0] B,      // Multiplier
    output reg [15:0] product, // Product
    output reg done     // Done flag
);

    reg [2:0] bit_count;  // Tracks which bit we're processing (0-7)
    reg [7:0] multiplicand; // Shifted version of A
    reg [7:0] multiplier;   // Shifted version of B
    
    always @(posedge clk) begin
        if (start) begin
            // Initialize on start
            product <= 16'b0;
            multiplicand <= A;
            multiplier <= B;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else if (!done) begin
            // Process current bit
            if (multiplier[0]) begin
                product <= product + multiplicand;
            end
            
            // Shift and prepare for next bit
            multiplicand <= multiplicand << 1;
            multiplier <= multiplier >> 1;
            bit_count <= bit_count + 1;
            
            // Check for completion (all bits processed or remaining bits are 0)
            if (bit_count == 3'd7 || multiplier == 8'b0) begin
                done <= 1'b1;
            end
        end
    end

endmodule