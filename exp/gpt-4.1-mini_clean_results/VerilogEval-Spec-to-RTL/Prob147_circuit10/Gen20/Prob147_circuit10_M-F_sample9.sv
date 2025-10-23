module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

// Compute next_state combinationally from current state and inputs
always @(*) begin
    if (~a && b)
        next_state = 1'b1;
    else if (a && b)
        next_state = 1'b0;
    else
        next_state = state; // hold current state
end

// Sequential block: update state and output q on rising clock edge
always @(posedge clk) begin
    state <= next_state;
    q <= state; // output q reflects the stored state (previous next_state)
end

// Initialize state and q to zero
initial begin
    state = 1'b0;
    q = 1'b0;
end

endmodule