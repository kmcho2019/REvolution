module right_shifter #(
    parameter WIDTH = 8      // Configurable shift register width
)(
    input wire clk,          // Clock input
    input wire reset_n,      // Active-low synchronous reset (optional)
    input wire d,            // Data input
    output reg [WIDTH-1:0] q // Shift register output
);

// Initialize register to zero
initial begin
    q = {WIDTH{1'b0}};
end

// Right shift operation with optional reset
always @(posedge clk) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end else begin
        q <= {d, q[WIDTH-1:1]};  // Efficient right shift with input insertion
    end
end

endmodule