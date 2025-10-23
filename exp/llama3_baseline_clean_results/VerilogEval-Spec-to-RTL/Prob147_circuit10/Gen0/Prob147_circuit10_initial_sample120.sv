module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (b == 0 && a == 1) begin
        state <= ~state;
    end
    if (b == 1) begin
        q <= state;
    end else if (a == 0) begin
        q <= q;
    end else begin
        q <= ~q;
    end
end

endmodule