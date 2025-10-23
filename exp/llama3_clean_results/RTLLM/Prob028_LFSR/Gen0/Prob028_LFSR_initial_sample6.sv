module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero when rst is high
    end else begin
        // Calculate the feedback signal by XORing out[3] and out[2], then inverting
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the LFSR to the left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule