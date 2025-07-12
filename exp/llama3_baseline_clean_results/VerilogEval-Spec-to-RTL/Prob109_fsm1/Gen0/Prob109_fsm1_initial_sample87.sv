module TopModule(
    input         clk,
    input         areset,
    input         in,
    output        out
);

// Enum for states
enum logic [0:0] {STATE_B, STATE_A} current_state, next_state;

// Combinational logic for next state
always_comb begin
    case(current_state)
        STATE_B: next_state = (in) ? STATE_B : STATE_A;
        STATE_A: next_state = (in) ? STATE_A : STATE_B;
        default: next_state = STATE_B;
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= STATE_B;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign out = (current_state == STATE_A) ? 0 : 1;

endmodule