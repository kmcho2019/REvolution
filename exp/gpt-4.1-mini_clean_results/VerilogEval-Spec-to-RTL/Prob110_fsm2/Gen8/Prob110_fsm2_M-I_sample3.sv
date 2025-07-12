module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Sequential logic: state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) 
        state <= OFF;
    else 
        state <= next_state;
end

// Combinational logic to determine next_state
always @(*) begin
    case(state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Output combinational logic: Moore output depends on current state
assign out = (state == ON);

endmodule