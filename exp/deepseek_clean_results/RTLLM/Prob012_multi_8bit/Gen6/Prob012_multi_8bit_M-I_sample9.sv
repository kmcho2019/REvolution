module multi_8bit (
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg processing;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= 16'b0;
            done <= 1'b1;
            processing <= 1'b0;
        end else if (start && !processing) begin
            // Initialize registers
            multiplicand <= A;
            multiplier <= B;
            accumulator <= 16'b0;
            bit_counter <= 3'b0;
            done <= 1'b0;
            processing <= 1'b1;
        end else if (processing) begin
            if (multiplier == 8'b0) begin
                // Early termination if remaining bits are zero
                product <= accumulator;
                done <= 1'b1;
                processing <= 1'b0;
            end else if (bit_counter == 3'd7) begin
                // Final bit processing
                if (multiplier[0]) begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                product <= accumulator;
                done <= 1'b1;
                processing <= 1'b0;
            end else begin
                // Process current bit
                if (multiplier[0]) begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                
                // Shift registers for next cycle
                multiplicand <= multiplicand << 1;
                multiplier <= multiplier >> 1;
                bit_counter <= bit_counter + 1;
            end
        end
    end

    // Clock gating to reduce power when idle
    wire gated_clk = clk & (processing | start);
    
endmodule