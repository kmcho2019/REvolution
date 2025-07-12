module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

reg next_state;

// Combinational logic for next state
always @(*) begin
    case ({a, b})
        2'b01: next_state = 1'b1; // When a=0, b=1, next_state = 1
        2'b11: next_state = (state) ? 1'b0 : 1'b0; // When a=1, b=1, next_state depends on current state
        default: next_state = state; // Otherwise, next_state remains the same as current state
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    state <= next_state;
end

// Combinational logic for output q
assign q = (state) || (a && ~b);

endmodule