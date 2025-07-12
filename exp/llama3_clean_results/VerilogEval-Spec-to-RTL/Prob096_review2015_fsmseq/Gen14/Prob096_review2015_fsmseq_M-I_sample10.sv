module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states using binary encoding for potential area savings
enum logic [2:0] {
    IDLE = 3'b000,
    STATE_1 = 3'b001,
    STATE_11 = 3'b010,
    STATE_110 = 3'b011,
    STATE_1101 = 3'b100
} state, next_state;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Simplify the combinational logic for state transitions
always @(*) begin
    case(state)
        IDLE: next_state = data ? STATE_1 : IDLE;
        STATE_1: next_state = data ? STATE_11 : IDLE;
        STATE_11: next_state = data ? STATE_11 : STATE_110;
        STATE_110: next_state = data ? STATE_1101 : IDLE;
        STATE_1101: next_state = STATE_1101;
        default: next_state = IDLE;
    endcase
end

// Clocked logic for state updates and start_shifting control
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        // Set start_shifting to 1 when entering STATE_1101 and keep it set
        if(next_state == STATE_1101) begin
            start_shifting <= 1;
        end else if(state == STATE_1101) begin
            // Once in STATE_1101, keep start_shifting set to 1
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule