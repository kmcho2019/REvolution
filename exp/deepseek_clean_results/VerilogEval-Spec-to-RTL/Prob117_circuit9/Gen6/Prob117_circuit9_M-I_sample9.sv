module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire clk_en = ~a;  // Clock enable when a=0
reg gated_clk;

always @(*) begin
    gated_clk = clk & clk_en;
end

always @(posedge gated_clk or posedge a) begin
    if (a) begin
        q <= 3'd4;  // synchronous reset to 4 when a=1
    end else begin
        q <= (q < 3'd6) ? q + 3'd1 : 3'd0;  // simpler increment condition
    end
end

endmodule