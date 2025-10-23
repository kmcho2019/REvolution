module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (q == 9)
        next_q = 0;
    else
        next_q = q + 1;
end

always @(posedge clk) begin
    if (reset)
        q <= 0;
    else
        q <= next_q;
end

endmodule