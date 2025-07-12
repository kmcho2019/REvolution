module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Enum for states
typedef enum logic [1:0] {
    IDLE = 2'b00,
    PULSE_START = 2'b01,
    PULSE_END = 2'b10
} state_t;

reg [1:0] state;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    // Transition to PULSE_START state
                    state <= PULSE_START;
                    data_out <= 0;
                end else begin
                    // Stay in IDLE state
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_START: begin
                if (~data_in) begin
                    // Transition to PULSE_END state
                    state <= PULSE_END;
                    data_out <= 1;
                end else begin
                    // Stay in PULSE_START state
                    state <= PULSE_START;
                    data_out <= 0;
                end
            end
            PULSE_END: begin
                // Transition to IDLE state
                state <= IDLE;
                data_out <= 0;
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule