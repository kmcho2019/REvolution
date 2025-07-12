module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset_n,    // Active-low synchronous reset
    input wire enable,    // Clock gating control
    input wire d,         // Input bit
    output reg [WIDTH-1:0] q
);

// Gated clock implementation
wire gated_clk;
assign gated_clk = clk & enable;

always @(posedge gated_clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end else begin
        q <= {d, q[WIDTH-1:1]};  // Efficient right shift with new MSB
    end
end

endmodule