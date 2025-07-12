module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Initialize the LFSR to zero upon reset as per the problem statement
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal directly within the clocked block
        // The feedback is the inversion of the XOR of the most significant bit and the second most significant bit
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule