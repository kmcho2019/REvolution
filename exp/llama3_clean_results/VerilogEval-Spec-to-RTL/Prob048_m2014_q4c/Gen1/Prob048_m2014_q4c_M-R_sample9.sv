module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg next_q;

always @(posedge clk) begin
    if (r) begin
        next_q <= 0;
    end else begin
        next_q <= d;
    end
    q <= next_q;
end

endmodule