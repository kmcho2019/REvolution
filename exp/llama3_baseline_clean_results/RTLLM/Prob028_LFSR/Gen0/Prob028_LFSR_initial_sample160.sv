module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Initialize LFSR to zero when reset is high
    end else begin
        // Calculate the feedback signal
        wire feedback;
        assign feedback = ~(out[3] ^ out[2]); // Invert the XOR of the most significant and second most significant bits
        
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback}; 
    end
end

endmodule