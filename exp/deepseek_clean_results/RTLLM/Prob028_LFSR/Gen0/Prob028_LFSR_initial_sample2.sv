module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

// Feedback is XOR of out[3] and out[2], then inverted
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset to all zeros
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule