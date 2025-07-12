module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Combinational next-state logic
always @(*) begin
    case(state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Output combinational logic directly from state
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule