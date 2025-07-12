module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    PULSE_START,
    PULSE_END
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_START;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            PULSE_START: begin
                if (~data_in) begin
                    state <= PULSE_END;
                end else begin
                    state <= PULSE_START;
                end
                data_out <= 0;
            end
            PULSE_END: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= PULSE_END;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule