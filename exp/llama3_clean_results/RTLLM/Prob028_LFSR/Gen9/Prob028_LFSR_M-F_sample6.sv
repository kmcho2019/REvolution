// Define a 4-bit LFSR module
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Internal signal for the feedback
wire feedback;

// Calculate the feedback based on the XOR of the most significant bits
assign feedback = ~(out[3] ^ out[2]);

// Handle the clock edge and reset conditions
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out <= 4'b0;
    end else begin
        // Update the LFSR state by shifting left and inserting the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule