module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the finite state machine
enum logic [1:0] {IDLE, RISE, FALL} state, next_state;

// Initialize the state register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        if (state == FALL) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

// Define the next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = RISE;
            end else begin
                next_state = IDLE;
            end
        end
        RISE: begin
            if (~data_in) begin
                next_state = FALL;
            end else begin
                next_state = RISE;
            end
        end
        FALL: begin
            next_state = IDLE;
        end
    endcase
end

endmodule