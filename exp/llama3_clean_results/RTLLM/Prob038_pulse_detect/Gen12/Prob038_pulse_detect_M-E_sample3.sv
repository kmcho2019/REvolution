module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine states: IDLE (0), PULSE_START (1), PULSE_END (2)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= 2'b00; // Reset to IDLE state
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // Transition to PULSE_START state
                end
                data_out <= 1'b0;
            end
            2'b01: begin // PULSE_START state
                if (~data_in) begin
                    state <= 2'b10; // Transition to PULSE_END state
                end
                data_out <= 1'b0;
            end
            2'b10: begin // PULSE_END state
                if (~data_in) begin
                    state <= 2'b00; // Return to IDLE state
                end
                data_out <= 1'b1; // Set data_out to 1 in PULSE_END state
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule