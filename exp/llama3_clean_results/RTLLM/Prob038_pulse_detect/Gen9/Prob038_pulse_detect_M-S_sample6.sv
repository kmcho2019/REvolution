module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Simplified state machine

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0; // Reset state
        data_out <= 0; // Reset output
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to next state if data_in is 1
                end
                data_out <= 0; // Reset output
            end
            1: begin // Wait for next cycle
                if (data_in) begin
                    state <= 2; // Stay in this state if data_in remains 1
                end else begin
                    state <= 0; // Go back to IDLE if data_in becomes 0 too soon
                end
                data_out <= 0; // Reset output
            end
            2: begin // Check for falling edge
                if (!data_in) begin
                    state <= 0; // Transition back to IDLE state
                    data_out <= 1; // Set output to 1, indicating pulse detection
                end else begin
                    state <= 2; // Stay in this state if data_in remains 1
                    data_out <= 0; // Reset output
                end
            end
        endcase
    end
end

endmodule