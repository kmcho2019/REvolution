module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback is XOR of bits 3 and 2 (most significant bits)
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001; // Initialize to non-zero value
    end
    else begin
        // Standard Fibonacci LFSR operation
        out <= {out[2:0], feedback};
    end
end

endmodule