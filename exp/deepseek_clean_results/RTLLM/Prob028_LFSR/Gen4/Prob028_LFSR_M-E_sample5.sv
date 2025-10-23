module LFSR #(
    parameter WIDTH = 4,                     // Configurable width
    parameter POLYNOMIAL = 4'b1100           // Feedback polynomial (taps)
) (
    input wire clk,                           // Clock input
    input wire rst,                           // Active-high reset
    input wire en,                            // Output enable
    output reg [WIDTH-1:0] out               // LFSR output
);

localparam SEED = {WIDTH{1'b1}};             // Non-zero initial seed

// Feedback calculation using polynomial taps
wire feedback;
assign feedback = ^(out & POLYNOMIAL);       // XOR all tapped bits

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;                         // Initialize to all 1s
    end else if (en) begin
        out <= {out[WIDTH-2:0], feedback};   // Shift left with feedback
    end
end

endmodule