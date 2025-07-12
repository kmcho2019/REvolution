module LFSR (
    input clk,            // Clock signal
    input rst,            // Active-high synchronous reset
    output reg [3:0] out  // Current LFSR state
);

// Feedback calculation: XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        // Initialize to non-zero value (4'b0001) to prevent lock-up
        out <= 4'b0001;
    end 
    else begin
        // Standard LFSR operation: shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule