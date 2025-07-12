module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation: XOR of MSB and second MSB, then invert
wire feedback = ~(out[3] ^ out[2]);

// On rising edge of clock, if reset is high, initialize to zero; otherwise, shift left and insert new feedback at LSB
always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0; // Initialize to zero on reset
    end else begin
        out <= {out[2:0], feedback}; // Shift left and insert new feedback at LSB
    end
end

endmodule