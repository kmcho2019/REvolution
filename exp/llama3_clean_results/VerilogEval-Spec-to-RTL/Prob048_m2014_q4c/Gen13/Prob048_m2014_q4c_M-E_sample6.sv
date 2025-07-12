module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Generate a gated clock signal based on the reset
wire gated_clk;
assign gated_clk = clk & ~r;

// Use the gated clock to drive the D flip-flop
always @(posedge gated_clk) begin
    q <= d; // Assign d to q at each positive edge of the gated clock
end

// Ensure q is reset to 0 when r is high
always @(r) begin
    if (r) begin
        q <= 1'b0; // Reset q to 0 when r is high
    end
end

endmodule