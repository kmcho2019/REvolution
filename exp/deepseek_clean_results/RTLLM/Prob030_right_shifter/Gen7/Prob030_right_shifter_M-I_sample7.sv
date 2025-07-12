module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset_n,    // Active-low synchronous reset
    input wire en,         // Clock enable
    input wire d,          // Input bit
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Reset all bits
    end
    else if (en) begin
        q <= {d, q[WIDTH-1:1]};  // Shift right with new bit
    end
end

endmodule