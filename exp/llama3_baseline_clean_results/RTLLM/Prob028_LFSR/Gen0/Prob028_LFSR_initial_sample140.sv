module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Initialize the output to zero
initial out = 0;

// On the rising edge of the clock
always @ (posedge clk) begin
    // If reset is high, initialize the register to zero
    if (rst) begin
        out <= 0;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, and then inverting the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule