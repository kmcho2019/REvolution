module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    if (b)
        next_state = ~(a ^ state);  // next state is XNOR of a and state when b=1
    else
        next_state = state;          // hold state when b=0

    q = b ? a : state;               // q = a when b=1 else q=state
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule