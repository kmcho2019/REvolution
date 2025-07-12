module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [7:0] rotated_A;
    reg [2:0] bit_counter;
    reg [15:0] accumulator;
    reg computing;

    always @(*) begin
        if (!computing) begin
            // Initialize when not computing
            rotated_A = A;
            accumulator = 0;
            bit_counter = 0;
        end
    end

    always @(posedge clk) begin
        if (start) begin
            computing <= 1'b1;
        end

        if (computing) begin
            // If current bit is set, add rotated A
            if (B[bit_counter]) begin
                accumulator <= accumulator + rotated_A;
            end

            // Rotate A left by 1 bit
            rotated_A <= {rotated_A[6:0], 1'b0};

            // Increment bit counter
            bit_counter <= bit_counter + 1;

            // Check if done
            if (bit_counter == 3'd7) begin
                product <= accumulator;
                computing <= 1'b0;
            end
        end
    end

    // Clock and start signal (would be part of larger system)
    input clk;
    input start;

endmodule