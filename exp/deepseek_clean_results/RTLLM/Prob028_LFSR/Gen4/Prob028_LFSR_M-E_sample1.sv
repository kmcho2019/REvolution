module LFSR (
    input clk,            // Clock signal
    input rst,            // Asynchronous reset
    input [3:0] seed,     // Initial seed value
    output reg [3:0] out, // Current LFSR state
    output reg valid      // High when LFSR is initialized
);

wire feedback = out[0] ^ out[3];  // XOR of bits 0 and 3 for feedback

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= seed;       // Load seed value on reset
        valid <= 1'b1;    // Indicate valid output
    end
    else begin
        if (out == 4'b0000) begin
            out <= seed;    // Prevent lock-up at zero state
        end
        else begin
            // Right shift with feedback at MSB
            out <= {feedback, out[3:1]};
        end
        valid <= 1'b1;     // Always valid after first clock
    end
end

endmodule