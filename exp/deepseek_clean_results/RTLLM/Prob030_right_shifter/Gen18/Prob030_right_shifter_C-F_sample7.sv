module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output reg [7:0] q
);

// Efficient clock gating
wire gated_clk;
assign gated_clk = clk & enable;

// Optimized shift operation with direct register update
always @(posedge gated_clk) begin
    q <= {d, q[7:1]};  // Combined right shift and MSB insertion
end

endmodule