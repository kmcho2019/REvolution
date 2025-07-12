module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Define states
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S11 = 3'b010,
    S110 = 3'b011,
    S1101 = 3'b100
} state, next_state;

// Assign output based on state
assign start_shifting = (state == S1101) ? 1'b1 : 1'b0;

// State machine logic
always_comb begin
    case (state)
        S0: next_state = (data == 1'b1) ? S1 : S0;
        S1: next_state = (data == 1'b1) ? S11 : S0;
        S11: next_state = (data == 1'b0) ? S110 : S1;
        S110: next_state = (data == 1'b1) ? S1101 : S0;
        S1101: next_state = S1101; // Stay in this state forever
        default: next_state = S0;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

endmodule