module right_shifter #(
    parameter USE_ENABLE = 0  // Make enable optional
)(
    input wire clk,
    input wire d,
    input wire enable,  // Optional data gating control
    output reg [7:0] q = 8'b0  // Initialize to 0 (Verilog-2001 style)
);

// Power-optimized shift with data gating
always @(posedge clk) begin
    if (!USE_ENABLE || enable) begin
        q <= {d, q[7:1]};  // Efficient single-expression shift
    end
end

endmodule