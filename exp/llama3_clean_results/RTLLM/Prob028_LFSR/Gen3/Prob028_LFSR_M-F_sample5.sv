module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero when rst is high
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and apply feedback
    end
end

endmodule