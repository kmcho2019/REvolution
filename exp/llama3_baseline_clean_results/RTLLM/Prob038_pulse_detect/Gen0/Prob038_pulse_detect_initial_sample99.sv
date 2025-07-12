module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {
    IDLE = 2'b00,
    PULSE_START = 2'b01,
    PULSE_END = 2'b10
} state, next_state;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= PULSE_START;
                    data_out <= 1'b0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            PULSE_START: begin
                if (~data_in) begin
                    next_state <= PULSE_END;
                    data_out <= 1'b1;
                end else begin
                    next_state <= PULSE_START;
                    data_out <= 1'b0;
                end
            end
            PULSE_END: begin
                next_state <= IDLE;
                data_out <= 1'b0;
            end
            default: begin
                next_state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule