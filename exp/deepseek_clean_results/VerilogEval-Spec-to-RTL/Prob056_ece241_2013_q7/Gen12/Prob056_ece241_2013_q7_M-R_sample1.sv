module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg next_Q;

// Combinational logic for next state
always @(*) begin
    if (j == 0 && k == 0) next_Q = Q;       // Hold state
    else if (j == 0 && k == 1) next_Q = 0;  // Reset
    else if (j == 1 && k == 0) next_Q = 1;  // Set
    else next_Q = ~Q;                       // Toggle (j=1,k=1)
end

// Sequential logic for state update
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule