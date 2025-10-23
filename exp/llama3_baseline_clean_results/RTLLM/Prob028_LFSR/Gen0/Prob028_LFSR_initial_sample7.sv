module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Calculate the feedback signal: XOR of MSB and second MSB, then invert
wire feedback = ~(out[3] ^ out[2]);

// Handle reset and shifting operation
always @(posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero
        out <= 4'b0000;
    end else begin
        // Shift bits left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule