module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] state, next_state;

// Next state logic based on current state and inputs
always_comb begin
    case(state)
        1'b0: next_state = (j == 1'b1)? 1'b1 : 1'b0; // OFF state transitions
        1'b1: next_state = (k == 1'b1)? 1'b0 : 1'b1; // ON state transitions
        default: next_state = 1'b0;
    endcase
end

// Output logic based on current state
always_comb begin
    out = (state == 1'b1)? 1'b1 : 1'b0; // Output is 1 in ON state, 0 in OFF state
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) state <= 1'b0;
    else state <= next_state;
end

endmodule