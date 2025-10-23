module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Stability detector for clock gating
reg [7:0] prev_d;
wire stable = (d == prev_d);

// Clock gating control
wire gated_clk = stable ? 1'b0 : clk;

always @(posedge gated_clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;
        prev_d <= 8'b0;
    end
    else begin
        q <= d;
        prev_d <= d;
    end
end

endmodule