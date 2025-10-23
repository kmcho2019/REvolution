module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// LFSR logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001; // Initialize to a non-zero state to start the sequence
    end else begin
        // Calculate the feedback signal
        reg feedback;
        assign feedback = ~(out[3] ^ out[2]); // Invert the XOR of the most significant and second most significant bits
        
        // Shift the bits and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule