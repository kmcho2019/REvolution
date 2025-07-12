module LFSR #(
    parameter WIDTH = 4         // Configurable LFSR width
) (
    input wire clk,             // Clock input
    input wire rst_n,           // Active low reset (better for FPGA)
    output reg [WIDTH-1:0] out, // LFSR output
    output wire valid           // Output valid indicator
);

// Synchronize reset
reg rst_sync1, rst_sync;
always @(posedge clk) begin
    rst_sync1 <= ~rst_n;
    rst_sync <= rst_sync1;
end

// Feedback polynomial: x^4 + x + 1 (standard maximal-length for 4-bit)
wire feedback = out[WIDTH-1] ^ out[1]; // XOR of MSB and bit 1

// Clock gating for power optimization
wire lfsr_clk_en = |out;               // Enable when not all zeros
reg gated_clk;
always @(posedge clk) begin
    gated_clk <= lfsr_clk_en & ~rst_sync;
end

// LFSR shift register with parallel output
always @(posedge clk) begin
    if (rst_sync) begin
        out <= {WIDTH{1'b1}}; // Reset to all 1s (better for LFSR)
    end else if (gated_clk) begin
        out <= {out[WIDTH-2:0], feedback};
    end
end

// Valid signal (high when not in reset and clock enabled)
assign valid = ~rst_sync & lfsr_clk_en;

endmodule