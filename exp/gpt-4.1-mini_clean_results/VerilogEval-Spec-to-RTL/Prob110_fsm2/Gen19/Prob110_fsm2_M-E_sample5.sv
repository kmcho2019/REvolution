module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

localparam OFF = 1'b1;
localparam ON  = 1'b0;

reg state, next_state;

// Combinational next state logic
always @(*) begin
    if (state == OFF) 
        next_state = j ? ON : OFF;
    else // state == ON
        next_state = k ? OFF : ON;
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Output logic: Moore output depends only on current state
assign out = ~state; // ON=0 => out=1, OFF=1 => out=0

endmodule