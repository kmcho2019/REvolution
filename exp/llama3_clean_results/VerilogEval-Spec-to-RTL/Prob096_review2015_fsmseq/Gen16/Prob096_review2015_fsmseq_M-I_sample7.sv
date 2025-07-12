module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Use enum for better readability and maintainability
enum logic [2:0] {IDLE, STATE1, STATE2, STATE3, FINAL} state, next_state;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Combinational logic for next state
always @(*) begin
    case(state)
        IDLE: next_state = data ? STATE1 : IDLE; 
        STATE1: next_state = data ? STATE2 : IDLE; 
        STATE2: next_state = ~data ? STATE3 : STATE2; 
        STATE3: next_state = data ? FINAL : IDLE; 
        FINAL: next_state = FINAL; 
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
        if(next_state == FINAL) begin
            start_shifting <= 1; 
        end else if(state != FINAL) begin
            start_shifting <= 0; 
        end
    end
end

endmodule