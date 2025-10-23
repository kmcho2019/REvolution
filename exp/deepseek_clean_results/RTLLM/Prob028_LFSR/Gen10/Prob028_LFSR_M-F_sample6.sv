module LFSR (
    input  wire clk,          // Clock input
    input  wire rst,          // Synchronous reset
    output reg  [3:0] out     // 4-bit LFSR output
);

// Feedback calculation with inversion as specified
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;       // Initialize to non-zero value
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
    end
end

endmodule