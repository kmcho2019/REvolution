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

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Next state logic combinational block
always @(*) begin
    if (state == OFF)
        next_state = j ? ON : OFF;
    else // state == ON
        next_state = k ? OFF : ON;
end

// Output assigned combinationally from state
assign out = (state == ON);

endmodule