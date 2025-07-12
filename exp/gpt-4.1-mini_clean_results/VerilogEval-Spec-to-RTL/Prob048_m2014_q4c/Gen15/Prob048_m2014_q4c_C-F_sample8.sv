module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);
    always @(posedge clk) begin
        reg next_q;
        next_q = r ? 1'b0 : d;
        q <= next_q;
    end
endmodule