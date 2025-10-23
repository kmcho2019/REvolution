module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [3:0] bit_counter;  // Counts 0-9 (10 bits total)
    reg [9:0] frame_reg;    // Stores the complete frame

    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 0;
            frame_reg <= 10'b1111111111;  // Initialize to idle state
            done <= 0;
        end else begin
            // Default assignment
            done <= 0;

            // Shift in new bit
            frame_reg <= {frame_reg[8:0], in};

            // Counter logic
            if (bit_counter == 9) begin
                // Check for valid frame (start=0, stop=1)
                if (frame_reg[9] == 0 && in == 1) begin
                    done <= 1;
                end
                bit_counter <= 0;
            end else if (bit_counter == 0) begin
                // Wait for start bit
                if (in == 0) begin
                    bit_counter <= 1;
                end
            end else begin
                bit_counter <= bit_counter + 1;
            end
        end
    end

endmodule