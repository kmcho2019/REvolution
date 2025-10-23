module multi_8bit (
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg ready
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= 16'b0;
            ready <= 1'b1;
            bit_counter <= 3'b0;
            accumulator <= 16'b0;
            multiplicand <= 8'b0;
            multiplier <= 8'b0;
        end else if (start && ready) begin
            // Initialize registers when starting
            multiplicand <= A;
            multiplier <= B;
            accumulator <= 16'b0;
            bit_counter <= 3'b0;
            ready <= 1'b0;
        end else if (!ready) begin
            // Shift-and-add operation
            if (multiplier[bit_counter]) begin
                accumulator <= accumulator + (multiplicand << bit_counter);
            end
            
            // Increment counter and check completion
            bit_counter <= bit_counter + 1;
            if (bit_counter == 3'd7) begin
                product <= accumulator;
                ready <= 1'b1;
            end
        end
    end

endmodule