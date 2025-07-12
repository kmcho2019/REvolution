module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

reg state; // 1-bit register to hold the state
assign out = state; // assign output as the current state

reg next_state; // 1-bit register to hold the next state

// Combinational logic to determine next state
always @(*) begin
    case (state)
        STATE_A: 
            case (in)
                1'b0: next_state = STATE_B; // transition from A to B on input 0
                1'b1: next_state = STATE_A; // stay in state A on input 1
            endcase
        STATE_B: 
            case (in)
                1'b0: next_state = STATE_A; // transition from B to A on input 0
                1'b1: next_state = STATE_B; // stay in state B on input 1
            endcase
    endcase
end

// Sequential logic to update state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_B; // asynchronous reset to state B
    end else begin
        state <= next_state; // update state based on next_state
    end
end

endmodule