module LFSR (
    input wire clk,        // 1-bit clock
    input wire rst,        // 1-bit active-high reset
    output reg [3:0] out   // 4-bit output
);

// Feedback calculation: XOR of two MSBs then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;    // Synchronous reset to all zeros
    end
    else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule