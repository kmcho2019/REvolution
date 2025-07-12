module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    if (a == 1'b0 && b == 1'b0)
        next_state = state;           // hold current state
    else if (a == 1'b0 && b == 1'b1)
        next_state = 1'b1;            // set state to 1
    else if (a == 1'b1 && b == 1'b0)
        next_state = 1'b0;            // set state to 0
    else // a == 1'b1 && b == 1'b1
        next_state = ~state;          // toggle state
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0; // initialize to zero
end

endmodule