module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;
wire gated_clk = clk & (~a | (q != 3'd4));  // Clock gating when a=1 and q=4

always @(posedge gated_clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        next_q = (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule