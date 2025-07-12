module TopModule (
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
    q <= next_q;
end

endmodule