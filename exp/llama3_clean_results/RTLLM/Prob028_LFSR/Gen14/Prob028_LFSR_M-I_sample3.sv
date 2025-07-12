// Improved 4-bit LFSR module
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Internal wire for feedback calculation
wire feedback;

// Calculate feedback by XORing MSB and second MSB, then inverting
assign feedback = ~(out[3] ^ out[2]);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Shift current state left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule