module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg next_q;

always @(*) begin
    if (r)
        next_q = 1'b0;
    else
        next_q = d;
end

always @(posedge clk) begin
    if (q != next_q)
        q <= next_q;
    // else no change to q to reduce unnecessary toggling
end

endmodule