module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Reset the LFSR state to zero on active high reset
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        wire feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits to the left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule