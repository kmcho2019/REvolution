module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Registered output
);

// Combined feedback and shift operation
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;    // Initialize to non-zero state
    end
    else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift left and insert inverted XOR feedback
    end
end

endmodule