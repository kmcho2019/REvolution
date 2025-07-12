module LFSR (
    input clk,        // 1-bit clock
    input rst,        // 1-bit active-high reset
    output reg [3:0] out  // 4-bit output (directly from reg)
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Synchronous reset
    end
    else begin
        // Shift left and insert inverted XOR of two MSBs at LSB
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule