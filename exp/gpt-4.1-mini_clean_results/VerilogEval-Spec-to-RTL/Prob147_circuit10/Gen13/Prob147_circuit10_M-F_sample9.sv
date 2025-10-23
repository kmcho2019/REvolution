module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    // Next state logic: reset state to 0 when both b and a are high; else hold state
    if (b & a)
        next_state = 1'b0;
    else
        next_state = state;
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = state | (b & ~a);

initial begin
    state = 1'b0; // Initialize state to 0 for simulation start
end

endmodule