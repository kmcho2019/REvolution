module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation: XOR of MSB and second MSB, then invert
wire feedback = ~(out[3] ^ out[2]);

// Sequential logic for clock-synchronized shifting operation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero on reset
        out <= 4'd0;
    end else begin
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule