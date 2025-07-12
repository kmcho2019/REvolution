module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg [3:0] bit_counter;  // Counts 0-9 (needs 4 bits)
    reg [9:0] frame_reg;    // Stores complete frame
    reg waiting_for_idle;

    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 0;
            frame_reg <= 10'b1111111111;  // Initialize to idle state
            done <= 0;
            waiting_for_idle <= 0;
        end else begin
            done <= 0;  // Default value

            if (waiting_for_idle) begin
                if (in) begin  // Line returned to idle
                    waiting_for_idle <= 0;
                    bit_counter <= 0;
                end
            end else begin
                // Shift in new bit
                frame_reg <= {in, frame_reg[9:1]};
                
                if (bit_counter == 9) begin
                    // Check complete frame
                    if (frame_reg[9] == 0 && in == 1) begin  // Start=0, Stop=1
                        done <= 1;
                        bit_counter <= 0;
                    end else begin
                        waiting_for_idle <= 1;
                    end
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

endmodule