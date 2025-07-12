module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire gated_clk;
reg enable_reg;

// Clock gating for power optimization
assign gated_clk = clk & (reset | slowena);

always @(posedge gated_clk) begin
    if (reset) begin
        q <= 4'd0;
    end
    else begin
        q <= (q == 4'd9) ? 4'd0 : q + 1'b1;
    end
end

endmodule