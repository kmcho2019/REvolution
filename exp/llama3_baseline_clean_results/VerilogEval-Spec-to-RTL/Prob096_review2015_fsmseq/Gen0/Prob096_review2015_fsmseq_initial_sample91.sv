module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for states
enum logic [2:0] {IDLE, S1, S2, S3, FOUND} state, next_state;

// Combinational logic for next state
always_comb begin
    case(state)
        IDLE: next_state = (data == 1) ? S1 : IDLE;
        S1: next_state = (data == 1) ? S2 : (data == 0) ? IDLE : IDLE;
        S2: next_state = (data == 0) ? S3 : IDLE;
        S3: next_state = (data == 1) ? FOUND : IDLE;
        FOUND: next_state = FOUND;
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        start_shifting <= (state == FOUND || next_state == FOUND) ? 1 : 0;
    end
end

endmodule