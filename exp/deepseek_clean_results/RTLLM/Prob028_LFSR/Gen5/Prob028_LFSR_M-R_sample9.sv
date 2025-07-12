module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback is inverted XOR (XNOR) of bits 3 and 2
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Initialize to non-zero value
    end
    else begin
        // Normal operation with all-zero detection
        if (out == 4'b0000)
            out <= 4'b0001;  // Prevent lock-up state
        else
            out <= {out[2:0], feedback};  // Shift left with feedback
    end
end

endmodule