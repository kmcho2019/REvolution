module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_clk;
reg  reset_latch;

// Clock gating for reset
assign gated_clk = clk & ~r;

// Transparent latch for reset condition
always @(*) begin
    if (~clk) begin
        reset_latch <= r ? 1'b0 : d;
    end
end

// Main flip-flop
always @(posedge gated_clk) begin
    q <= reset_latch;
end

endmodule