module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire clk_en = ~a | (q != 3'd4);  // Clock gating when a=1 and q=4
wire gated_clk = clk & clk_en;

always @(posedge gated_clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else begin
        // More efficient terminal count detection (6 = 110)
        if (&q[2:1])  // Checks bits 2 and 1 (q[0] doesn't matter for 6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule