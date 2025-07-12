module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
assign out = state;

// State register with asynchronous reset and transition logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= OFF;
    else state <= next_state;
end

// Next state logic
always_comb begin
    case(state)
        OFF: next_state = j? ON : OFF;
        ON:  next_state = k? OFF : ON;
    endcase
end

endmodule