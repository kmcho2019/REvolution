module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire gated_clk;
assign gated_clk = clk & (~a | (q != 3'd4));

always @(posedge gated_clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        q <= (q + 3'd1) % 3'd7;  // modulo operation for wrap-around
    end
end

endmodule