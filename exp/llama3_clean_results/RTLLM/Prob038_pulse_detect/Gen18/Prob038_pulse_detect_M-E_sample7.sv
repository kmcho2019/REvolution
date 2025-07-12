module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_DETECTED, 2: OUTPUT_PULSE
reg [1:0] counter; // Counter for high cycles
reg prev_data_in; // Previous value of data_in

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        state <= 0; // IDLE state
        counter <= 0;
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data_in && !prev_data_in) begin // Transition from 0 to 1
                    state <= 1; // Move to PULSE_DETECTED state
                    counter <= 1; // Start counting high cycles
                end
                prev_data_in <= data_in;
            end
            1: begin // PULSE_DETECTED
                if (data_in) begin // Still high
                    counter <= counter + 1; // Increment counter
                    if (counter == 3) begin // Reached max high cycles without transitioning back to low
                        state <= 0; // Return to IDLE
                        counter <= 0;
                    end
                end else if (!data_in && counter == 1) begin // Transitioned back to low after 1 high cycle
                    state <= 2; // Move to OUTPUT_PULSE state
                end else begin // Transitioned back to low but not after 1 high cycle
                    state <= 0; // Return to IDLE
                    counter <= 0;
                end
                prev_data_in <= data_in;
            end
            2: begin // OUTPUT_PULSE
                data_out <= 1; // Set data_out to 1
                state <= 0; // Return to IDLE
                counter <= 0;
                data_out <= 0; // Reset data_out after one cycle (this will be executed in the next clock cycle)
            end
        endcase
    end
end

endmodule