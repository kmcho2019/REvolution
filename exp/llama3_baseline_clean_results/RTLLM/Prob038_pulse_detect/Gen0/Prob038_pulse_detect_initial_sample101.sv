module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the finite state machine
enum logic [1:0] {
    IDLE,
    RISE,
    FALL
} state, next_state;

// Reset the FSM to the initial state when rst_n is low
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state <= RISE;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            RISE: begin
                if (~data_in) begin
                    next_state <= FALL;
                    data_out <= 0;
                end else begin
                    next_state <= RISE;
                    data_out <= 0;
                end
            end
            FALL: begin
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