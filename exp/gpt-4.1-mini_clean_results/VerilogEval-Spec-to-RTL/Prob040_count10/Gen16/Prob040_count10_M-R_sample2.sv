module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (reset)
        next_q = 4'd0;
    else if (q == 4'd9)
        next_q = 4'd0;
    else
        next_q = q + 4'd1;
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule