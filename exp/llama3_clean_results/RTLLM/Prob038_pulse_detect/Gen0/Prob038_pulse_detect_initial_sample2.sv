module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Initial state: IDLE
        data_out <= 0; // No pulse initially
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // Transition to PULSE_START state
                end else begin
                    state <= 0; // Stay in IDLE state
                end
                data_out <= 0; // No pulse in IDLE state
            end
            1: begin // PULSE_START state
                if (~data_in) begin
                    state <= 2; // Transition to PULSE_END state
                end else begin
                    state <= 1; // Stay in PULSE_START state
                end
                data_out <= 0; // No pulse in PULSE_START state
            end
            2: begin // PULSE_END state
                state <= 0; // Transition back to IDLE state
                data_out <= 1; // Pulse detected
            end
            default: begin
                state <= 0; // Default to IDLE state
                data_out <= 0; // No pulse by default
            end
        endcase
    end
end

endmodule