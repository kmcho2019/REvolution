module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Initialize the LFSR on reset
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Calculate the feedback signal
        reg fb;
        fb = ~(out[3] ^ out[2]); // Invert the result of XOR operation
        
        // Shift the bits left and insert the feedback signal at LSB
        out <= {out[2:0], fb};
    end
end

endmodule