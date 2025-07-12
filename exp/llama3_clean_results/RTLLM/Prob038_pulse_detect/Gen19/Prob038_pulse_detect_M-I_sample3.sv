module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the simplified FSM
enum logic [1:0] {IDLE, PULSE_START} state, next_state;

always @(posedge clk) begin
    if (~rst_n) begin // Synchronous reset
        state <= IDLE;
        data_out <= 0;
    end else begin
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
                    next_state <= IDLE;
                    data_out <= 1; // Set data_out to 1 at the end of a pulse
                end else begin
                    next_state <= PULSE_START;
                    data_out <= 0;
                end
            end
            default: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule