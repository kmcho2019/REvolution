module right_shifter #(
    parameter WIDTH = 8
) (
    input clk,
    input en,       // Enable signal for power gating
    input d,         // Input bit
    output reg [WIDTH-1:0] q = 0  // Initialized output
);

reg d_reg;  // Registered input to break critical path

always @(posedge clk) begin
    if (en) begin
        d_reg <= d;           // Register input separately
        q <= {d_reg, q[WIDTH-1:1]};  // Shift operation
    end
end

endmodule