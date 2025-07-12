module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (slowena)
        next_q = (q + 4'd1 > 4'd9) ? 4'd0 : q + 4'd1;
    else
        next_q = q;
end

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule