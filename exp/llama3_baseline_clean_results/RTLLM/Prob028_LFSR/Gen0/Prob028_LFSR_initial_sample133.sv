module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            // Reset the LFSR to zero when rst is high
            out <= 4'b0000;
        end else begin
            // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
            // and then inverting the result
            reg [3:0] next_out;
            reg fb;
            fb = ~(out[3] ^ out[2]);
            
            // Shift the bits in the register to the left and insert the new feedback value at the LSB
            next_out[3] = out[2];
            next_out[2] = out[1];
            next_out[1] = out[0];
            next_out[0] = fb;
            
            // Update the output
            out <= next_out;
        end
    end

endmodule