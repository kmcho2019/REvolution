module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    if (b == 1'b1 && a == 1'b0)
        next_state = 1'b1;         // Set state to 1 when b=1 and a=0
    else if (b == 1'b1 && a == 1'b1)
        next_state = ~state;       // Toggle state when both a and b are 1
    else
        next_state = state;        // Hold state otherwise
end

always @(posedge clk) begin
    state <= next_state;           // Update state at positive clock edge
end

assign q = state & ~(a & b);      // q is 1 if state=1 and not both a and b are 1

initial begin
    state = 1'b0;                 // Initialize state to 0 for simulation consistency
end

endmodule