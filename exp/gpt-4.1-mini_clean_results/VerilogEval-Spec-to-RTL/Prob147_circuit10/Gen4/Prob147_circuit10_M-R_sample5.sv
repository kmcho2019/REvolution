module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

reg next_state;

always @(*) begin
    if (a & b)
        next_state = ~state;     // toggle state
    else if (b & ~a)
        next_state = 1'b1;       // set state
    else
        next_state = 1'b0;       // reset state
end

assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule