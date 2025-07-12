module LFSR #(
    parameter WIDTH = 4,
    parameter SEED = 4'b0001  // Non-zero seed to avoid lock-up state
) (
    input  wire clk,
    input  wire rst,
    output reg  [WIDTH-1:0] out
);

// Feedback taps: bits 3 and 2 for 4-bit LFSR (standard maximal-length configuration)
wire feedback = out[WIDTH-1] ^ out[WIDTH-2];

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;  // Initialize with seed value
    end else begin
        out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule