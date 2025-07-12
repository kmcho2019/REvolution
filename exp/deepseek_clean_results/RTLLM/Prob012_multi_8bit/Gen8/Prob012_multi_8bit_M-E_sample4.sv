module multi_8bit (
    input clk,
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

    // Barrel shifter for multiplicand
    wire [15:0] shifted_multiplicand = multiplicand << bit_counter;

    always @(posedge clk) begin
        if (start) begin
            // Initialize registers
            multiplicand <= A;
            multiplier <= B;
            accumulator <= 16'b0;
            bit_counter <= 3'b0;
            done <= 1'b0;
            processing <= 1'b1;
        end
        else if (processing) begin
            if (multiplier[bit_counter]) begin
                // Add shifted multiplicand if current bit is set
                accumulator <= accumulator + shifted_multiplicand;
            end

            // Early termination if remaining bits are zero
            if ((bit_counter == 3'd7) || 
                ((bit_counter < 3'd7) && (multiplier >> (bit_counter + 1) == 0))) begin
                product <= accumulator;
                done <= 1'b1;
                processing <= 1'b0;
            end
            else begin
                bit_counter <= bit_counter + 1;
            end
        end
    end

endmodule