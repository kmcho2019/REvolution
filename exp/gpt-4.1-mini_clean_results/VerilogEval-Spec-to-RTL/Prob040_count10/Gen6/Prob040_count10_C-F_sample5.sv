module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    next_q = (q == 9) ? 0 : q + 1;
end

always @(posedge clk) begin
    if (reset)
        q <= 0;
    else
        q <= next_q;
end

endmodule