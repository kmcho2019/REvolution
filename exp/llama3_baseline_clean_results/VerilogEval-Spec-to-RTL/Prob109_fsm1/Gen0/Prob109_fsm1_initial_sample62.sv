module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 1 bit to represent 2 states: A (0) and B (1)
reg [0:0] next_state; // 1 bit to represent 2 states: A (0) and B (1)

// Asynchronous reset
always @(areset or state or in) begin
    if (areset) begin
        next_state = 1; // reset to state B
    end else begin
        case(state)
            1'b1: next_state = in ? 1'b1 : 1'b0; // state B
            1'b0: next_state = in ? 1'b0 : 1'b1; // state A
            default: next_state = 1'b1; // default to state B
        endcase
    end
end

// Update state at each clock cycle
always @(posedge clk) begin
    state <= next_state;
end

// Output is a function of the current state
assign out = state;

endmodule