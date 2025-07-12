module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] bit_counter;  // Counts 0-9 (needs 4 bits)
    reg [9:0] frame_reg;    // Stores complete frame (start + data + stop)

    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 0;
            frame_reg <= 10'b1111111111;  // Initialize to idle state
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default to not done
            
            // Shift in new bit
            frame_reg <= {in, frame_reg[9:1]};
            
            // Counter logic
            if (bit_counter == 0) begin
                // Waiting for start bit
                if (in == 0) begin
                    bit_counter <= 1;  // Start bit detected
                end
            end else begin
                if (bit_counter < 9) begin
                    bit_counter <= bit_counter + 1;
                end else begin
                    // Full frame received
                    if (frame_reg[9] == 0 && in == 1) begin  // Check start and stop bits
                        out_byte <= frame_reg[8:1];  // Extract data bits
                        done <= 1;
                    end
                    // Reset counter if line is idle (1), otherwise wait for stop bit
                    bit_counter <= (in == 1) ? 0 : bit_counter;
                end
            end
        end
    end

endmodule