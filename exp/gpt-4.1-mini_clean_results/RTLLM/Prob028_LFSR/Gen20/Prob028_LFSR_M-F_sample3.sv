module LFSR(
    input  wire       clk,     // 1-bit clock input
    input  wire       rst,     // synchronous active-high reset
    output reg  [3:0] out      // 4-bit LFSR state output
);

    // Calculate inverted XOR feedback of MSB and next MSB bits
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;  // Reset to zero
        end else begin
            // Shift left and insert feedback at LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule