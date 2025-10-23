module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

enum logic [2:0] {IDLE, DATA_1, DATA_11, DATA_110, DATA_1101} state, next_state;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Combinational logic for next state
always_comb begin
    case(state)
        IDLE: next_state = data? DATA_1 : IDLE;
        DATA_1: next_state = data? DATA_11 : IDLE;
        DATA_11: next_state = data? DATA_11 : IDLE;
        DATA_110: next_state = ~data? DATA_1101 : IDLE;
        DATA_1101: next_state = DATA_1101; // Remain in this state once reached
        default: next_state = IDLE;
    endcase
end

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(next_state == DATA_1101) begin
            start_shifting <= 1;
        end else if(state!= DATA_1101) begin
            start_shifting <= 0;
        end
    end
end

endmodule