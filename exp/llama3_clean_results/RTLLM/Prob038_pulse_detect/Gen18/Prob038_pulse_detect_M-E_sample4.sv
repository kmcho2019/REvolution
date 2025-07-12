module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the finite state machine
enum logic [1:0] {
    IDLE,
    RISING_EDGE,
    HIGH_STATE,
    FALLING_EDGE
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= RISING_EDGE;
                end else begin
                    next_state <= IDLE;
                end
                data_out <= 0;
            end
            RISING_EDGE: begin
                if (data_in) begin
                    next_state <= HIGH_STATE;
                end else begin
                    next_state <= IDLE;
                end
                data_out <= 0;
            end
            HIGH_STATE: begin
                if (!data_in) begin
                    next_state <= FALLING_EDGE;
                end else begin
                    next_state <= HIGH_STATE;
                end
                data_out <= 0;
            end
            FALLING_EDGE: begin
                next_state <= IDLE;
                data_out <= 1;
            end
            default: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule