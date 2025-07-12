module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a & b)
        state <= 1'b0;           // reset state if both a and b are 1
    else if (~state & b)
        state <= 1'b1;           // set state if b=1 and state=0
    else
        state <= state;          // hold state otherwise

    q <= state;
end

endmodule