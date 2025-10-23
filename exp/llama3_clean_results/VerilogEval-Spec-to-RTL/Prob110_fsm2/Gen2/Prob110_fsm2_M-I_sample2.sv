module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states explicitly for clarity, although the impact on PPA might be minimal
enum logic [0:0] {OFF = 1'b0, ON = 1'b1} state, next_state;

// Output logic remains straightforward
assign out = state;

// State transition logic could be kept the same for simplicity
always_comb begin
    case(state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= OFF;
    else state <= next_state;
end

endmodule