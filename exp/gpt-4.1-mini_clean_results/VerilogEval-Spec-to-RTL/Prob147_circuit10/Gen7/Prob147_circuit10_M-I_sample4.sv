module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Combinational logic for next state based on a, b, and current state
always @(*) begin
    if (b)            // when b=1
        next_state = ~state;   // toggle state
    else if (a)       // b=0 and a=1
        next_state = state;    // hold state if 1, else 0
    else              // a=0 and b=0
        next_state = 1'b0;     // reset to 0
end

// Sequential state update on posedge clk
always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

// Initialize state to 0 for simulation purposes
initial begin
    state = 1'b0;
end

endmodule