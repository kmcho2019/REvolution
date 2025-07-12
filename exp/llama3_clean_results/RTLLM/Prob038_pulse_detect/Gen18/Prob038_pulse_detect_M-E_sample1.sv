module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {IDLE, PULSE_START, PULSE_END} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= PULSE_START;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_START: begin
                if (~data_in) begin
                    next_state <= PULSE_END;
                    data_out <= 1; // Set data_out to 1 at the end of a pulse
                end else begin
                    next_state <= PULSE_START;
                    data_out <= 0;
                end
            end
            PULSE_END: begin
                next_state <= IDLE;
                data_out <= 0; // Reset data_out after a pulse
            end
            default: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule