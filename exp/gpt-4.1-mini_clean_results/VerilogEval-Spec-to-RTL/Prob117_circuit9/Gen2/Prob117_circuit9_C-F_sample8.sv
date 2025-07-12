module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] q_next;

always @(*) begin
    if (a)
        q_next = 3'd4;
    else
        q_next = (q == 3'd6) ? 3'd0 : q + 3'd1;
end

always @(posedge clk) begin
    if (q != q_next)
        q <= q_next;
end

endmodule