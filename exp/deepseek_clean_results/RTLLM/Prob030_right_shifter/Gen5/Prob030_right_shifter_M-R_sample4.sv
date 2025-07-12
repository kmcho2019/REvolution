module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output reg [7:0] q
);

// Clock gating
wire gated_clk;
assign gated_clk = clk & enable;

// Shift logic (combinational)
wire [7:0] next_q;
assign next_q = {d, q[7:1]};  // Right shift with new bit insertion

// Register update (sequential)
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule