// Corrected 4-bit LFSR module
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Handle the clock edge and reset conditions
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        // Calculate feedback as the inverted XOR of out[3] and out[2]
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule