module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] next_state_out; // 2-bit register to hold next state and output

// Lookup table for state transitions and output
always @(*) begin
    case ({state, in})
        2'b00: next_state_out = 2'b10; // State A, input 0, next state B, output 1
        2'b01: next_state_out = 2'b00; // State A, input 1, next state A, output 0
        2'b10: next_state_out = 2'b00; // State B, input 0, next state A, output 0
        2'b11: next_state_out = 2'b10; // State B, input 1, next state B, output 1
    endcase
end

reg state; // 1-bit register to hold the current state
assign out = state; // assign output as the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // asynchronous reset to state B (1)
        state <= 1'b1;
    end else begin
        state <= next_state_out[1]; // update state
    end
end

endmodule