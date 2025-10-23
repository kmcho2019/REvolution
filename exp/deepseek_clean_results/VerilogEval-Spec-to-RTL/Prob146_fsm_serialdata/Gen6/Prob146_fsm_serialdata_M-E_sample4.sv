module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Shift register holds complete 10-bit frame (start + 8 data + stop)
    reg [9:0] frame_reg;
    reg [3:0] bit_counter;  // Counts 0-9 (modulo 10)
    reg active;             // Single-bit state (0=IDLE, 1=ACTIVE)

    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b1111111111;  // Initialize to idle state
            bit_counter <= 0;
            active <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;
            
            // Continuous shift operation
            frame_reg <= {in, frame_reg[9:1]};
            bit_counter <= (bit_counter == 9) ? 0 : bit_counter + 1;

            // State transition and validation
            if (!active) begin
                // IDLE state - wait for start bit
                if (in == 0) begin
                    active <= 1;
                    bit_counter <= 0;
                end
            end else if (bit_counter == 9) begin
                // Complete frame received - validate
                if (frame_reg[9] == 0 && in == 1) begin  // start=0, stop=1
                    out_byte <= frame_reg[8:1];  // Extract data bits
                    done <= 1;
                end
                // Remain active if validation fails (wait for next start bit)
                active <= (in == 0) ? 1 : 0;
            end
        end
    end

endmodule