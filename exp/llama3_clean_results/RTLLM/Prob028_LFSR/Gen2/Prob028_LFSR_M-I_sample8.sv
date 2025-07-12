module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// D flip-flops to store each bit of the LFSR
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out <= 4'b0;
    end else begin
        // Calculate the feedback signal and shift the bits in one operation
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule