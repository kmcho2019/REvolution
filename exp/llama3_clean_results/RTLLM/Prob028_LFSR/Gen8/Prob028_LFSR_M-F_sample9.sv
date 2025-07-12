module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Internal signal for the feedback
reg [3:0] next_out;

// Initialize the output register
initial begin
    out = 4'b1000; // Initial value for the LFSR
end

// Calculate the feedback based on the XOR of the most significant bit and the second most significant bit
assign next_out = {out[2:0], ~(out[3] ^ out[2])};

// Handle the clock edge and reset conditions
always @ (posedge clk or posedge rst) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out <= 4'b0;
    end else begin
        // Update the LFSR state by shifting left and inserting the feedback at the LSB
        out <= next_out;
    end
end

endmodule