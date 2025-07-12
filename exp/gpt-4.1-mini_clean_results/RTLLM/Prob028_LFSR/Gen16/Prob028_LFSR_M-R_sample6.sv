module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

// Combinational feedback calculation: inverted XOR of out[3] and out[2]
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst)
        out <= 4'b0001;  // Non-zero seed on reset to avoid lock-up at zero
    else
        // Shift left by one and insert feedback at LSB
        out <= {out[2:0], feedback};
end

endmodule