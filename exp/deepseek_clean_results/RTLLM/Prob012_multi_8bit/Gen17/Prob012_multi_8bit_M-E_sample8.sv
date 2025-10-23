module multi_8bit(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] bit_counter;
    reg [15:0] accumulator;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator <= 16'b0;
            multiplicand <= 8'b0;
            multiplier <= 8'b0;
            bit_counter <= 3'b0;
            done <= 1'b0;
        end else begin
            if (bit_counter == 0) begin
                // Start new multiplication
                multiplicand <= A;
                multiplier <= B;
                accumulator <= 16'b0;
                done <= 1'b0;
                bit_counter <= bit_counter + 1;
            end else if (bit_counter < 8) begin
                // Process current bit
                if (multiplier[0]) begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                
                // Rotate registers for next bit
                multiplicand <= {1'b0, multiplicand[7:1]};  // Logical right shift
                multiplier <= {multiplier[0], multiplier[7:1]};  // Rotate right
                bit_counter <= bit_counter + 1;
            end else begin
                // Multiplication complete
                product <= accumulator;
                done <= 1'b1;
                bit_counter <= 0;
            end
        end
    end

endmodule