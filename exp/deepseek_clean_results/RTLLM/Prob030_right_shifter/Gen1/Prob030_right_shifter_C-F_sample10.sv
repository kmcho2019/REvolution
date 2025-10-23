module right_shifter #(
    parameter WIDTH = 8
) (
    input clk,
    input reset_n,    // Active-low synchronous reset
    input d,          // Input bit
    output reg [WIDTH-1:0] q  // Shift register output
);

// Initialize and synchronous reset
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Reset all bits to 0
    end
    else begin
        // Right shift by 1 and insert new bit at MSB
        // Could add clock gating here if q is not changing often
        q <= {d, q[WIDTH-1:1]};
    end
end

endmodule