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
    else if (q != d)
        next_q = d;
    else
        next_q = q;  // maintain current value to avoid toggling
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule