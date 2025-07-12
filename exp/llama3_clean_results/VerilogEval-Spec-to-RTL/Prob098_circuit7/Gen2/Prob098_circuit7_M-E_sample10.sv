module TopModule (
    input clk,
    input a,
    output reg q
);

// Define the states of the FSM
enum logic [0:0] {STATE_Q_HIGH, STATE_Q_LOW} state, next_state;

// Initialize the state
initial state = STATE_Q_HIGH;

// Sequential logic
always @(posedge clk) begin
    state <= next_state;
    case (state)
        STATE_Q_HIGH: begin
            if (a == 1'b0) begin
                next_state <= STATE_Q_HIGH; // Stay in STATE_Q_HIGH if 'a' is 0
                q <= 1'b1;
            end else begin
                next_state <= STATE_Q_LOW; // Transition to STATE_Q_LOW if 'a' is 1
                q <= 1'b0;
            end
        end
        STATE_Q_LOW: begin
            next_state <= STATE_Q_LOW; // Stay in STATE_Q_LOW regardless of 'a'
            q <= 1'b0;
        end
    endcase
end

endmodule