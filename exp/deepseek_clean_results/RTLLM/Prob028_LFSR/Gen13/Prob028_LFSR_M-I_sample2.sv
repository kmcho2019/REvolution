module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state (now directly registered)
);

// Combined state and output register
always @(posedge clk) begin
    if (rst) begin
        // Initialize to non-zero state to prevent lock-up
        out <= 4'b0001;
    end
    else begin
        // Efficient LFSR operation: shift left and insert inverted feedback
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule