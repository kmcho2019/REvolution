module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

wire gated_clk;
reg [3:0] next_out;

// Clock gating for power optimization
CLK_GATE clk_gate (
    .CLK(clk),
    .EN(valid_count || !rst_n),
    .GCLK(gated_clk)
);

// Next state logic
always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end
    else if (valid_count) begin
        next_out = (out == 4'd11) ? 4'b0000 : out + 1'b1;
    end
    else begin
        next_out = out;
    end
end

// Output register
always @(posedge gated_clk) begin
    out <= next_out;
end

endmodule