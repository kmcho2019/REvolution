module multi_8bit(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [2:0] bit_counter;
    reg [15:0] multiplicand;
    reg [15:0] accumulator;
    reg running;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= 16'b0;
            accumulator <= 16'b0;
            multiplicand <= 16'b0;
            bit_counter <= 3'b0;
            running <= 1'b0;
        end else begin
            if (!running) begin
                // Initialize operation
                if (|B) begin  // Only start if B is non-zero
                    running <= 1'b1;
                    multiplicand <= {8'b0, A};
                    accumulator <= 16'b0;
                    bit_counter <= 3'b0;
                end
            end else begin
                // Process current bit
                if (B[bit_counter]) begin
                    accumulator <= accumulator + multiplicand;
                end

                // Shift for next bit
                multiplicand <= multiplicand << 1;
                bit_counter <= bit_counter + 1;

                // Check completion
                if (bit_counter == 3'd7) begin
                    product <= accumulator;
                    running <= 1'b0;
                end
            end
        end
    end

endmodule