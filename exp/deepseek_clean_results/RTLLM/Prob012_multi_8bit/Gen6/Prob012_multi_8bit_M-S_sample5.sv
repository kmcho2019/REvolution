module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize on reset
            bit_counter <= 3'b0;
            multiplicand <= A;
            multiplier <= B;
            accumulator <= 16'b0;
            product <= 16'b0;
        end
        else if (bit_counter < 3'd8) begin
            // Shift-and-add operation
            if (multiplier[0]) begin
                accumulator <= accumulator + multiplicand;
            end
            
            // Prepare for next cycle
            multiplicand <= multiplicand << 1;
            multiplier <= multiplier >> 1;
            bit_counter <= bit_counter + 1;
            
            // Output final result when done
            if (bit_counter == 3'd7) begin
                product <= accumulator + (multiplier[0] ? multiplicand : 16'b0);
            end
        end
    end

endmodule