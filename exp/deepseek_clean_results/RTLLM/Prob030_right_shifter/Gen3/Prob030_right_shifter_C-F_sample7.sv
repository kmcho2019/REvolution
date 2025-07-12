module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire d,
    input wire enable,    // Clock gating control
    input wire reset_n,   // Active-low synchronous reset
    output reg [WIDTH-1:0] q
);

// Gated clock for power optimization
wire gated_clk;
assign gated_clk = clk & enable;

// Synchronous shift operation with reset
always @(posedge gated_clk) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end
    else begin
        q <= {d, q[WIDTH-1:1]};  // Efficient concatenation-based shift
    end
end

endmodule