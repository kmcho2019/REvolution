module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Clock gating control
    output reg [7:0] q
);

// Use clock gating to reduce power when not shifting
wire gated_clk;
assign gated_clk = clk & enable;

// Synchronous shift operation with implicit reset to 0
always @(posedge gated_clk) begin
    q <= {d, q[7:1]};  // Efficient concatenation-based shift
end

endmodule