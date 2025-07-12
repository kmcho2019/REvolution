module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset_n,    // Active-low synchronous reset
    input wire enable,    // Shift enable
    input wire d,         // Input bit
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end else if (enable) begin
        q <= {d, q[WIDTH-1:1]};  // Efficient right shift with new MSB
    end
end

endmodule