module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states
enum logic [1:0] {IDLE, PULSE_RISING, PULSE_FALLING} state, next_state;

// Initialize the state and data_out
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= PULSE_RISING;
                end else begin
                    next_state <= IDLE;
                end
                data_out <= 0;
            end
            PULSE_RISING: begin
                if (data_in) begin
                    next_state <= PULSE_RISING;
                end else begin
                    next_state <= PULSE_FALLING;
                end
                data_out <= 0;
            end
            PULSE_FALLING: begin
                if (~data_in) begin
                    next_state <= IDLE;
                    data_out <= 1;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule