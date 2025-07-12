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
    reg running;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= 16'b0;
            ready <= 1'b1;
            running <= 1'b0;
        end else if (start && ready) begin
            // Initialize operation
            multiplicand <= A;
            multiplier <= B;
            accumulator <= 16'b0;
            bit_counter <= 3'b0;
            ready <= 1'b0;
            running <= 1'b1;
        end else if (running) begin
            // Early termination check
            if (multiplier == 8'b0) begin
                product <= accumulator;
                ready <= 1'b1;
                running <= 1'b0;
            end else begin
                // Process LSB
                if (multiplier[0]) begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                
                // Shift operations
                multiplicand <= multiplicand << 1;
                multiplier <= multiplier >> 1;
                
                // Completion check
                if (bit_counter == 3'd7) begin
                    product <= accumulator;
                    ready <= 1'b1;
                    running <= 1'b0;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

endmodule