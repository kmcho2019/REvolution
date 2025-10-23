module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Reset all bits to zero on rst high
    end else begin
        // Calculate feedback: XOR of MSB and second MSB, then invert
        bit feedback = ~(out[3] ^ out[2]);
        
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule