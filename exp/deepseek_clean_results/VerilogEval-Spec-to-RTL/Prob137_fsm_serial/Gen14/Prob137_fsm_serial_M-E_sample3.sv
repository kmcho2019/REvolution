module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Shift register captures full frame (1 start + 8 data + 1 stop)
    reg [9:0] frame_reg;
    reg state; // 0=IDLE, 1=RECEIVE
    reg done_reg;

    // Early detection signals
    wire start_detected = (frame_reg[9] == 1'b0); // Start bit check
    wire stop_detected = (frame_reg[0] == 1'b1);  // Stop bit check
    wire frame_complete = (&frame_reg[8:1]);      // All data bits received

    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b1111111111; // Initialize to idle state
            state <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            // Default assignments
            done_reg <= 1'b0;
            frame_reg <= {frame_reg[8:0], in}; // Shift in new bit

            case (state)
                1'b0: begin // IDLE
                    if (start_detected) begin
                        state <= 1'b1;
                        frame_reg <= {8'b0, in, 1'b1}; // Pre-align for reception
                    end
                end

                1'b1: begin // RECEIVE
                    if (frame_complete && stop_detected) begin
                        state <= 1'b0;
                        done_reg <= 1'b1;
                        frame_reg <= 10'b1111111111; // Return to idle
                    end else if (frame_complete && !stop_detected) begin
                        // Wait for stop bit while maintaining frame
                        frame_reg <= {1'b1, frame_reg[9:1]};
                    end
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule