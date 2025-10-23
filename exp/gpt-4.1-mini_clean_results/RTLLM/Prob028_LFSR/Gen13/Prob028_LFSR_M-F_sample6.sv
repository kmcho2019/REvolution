module LFSR (
    input  wire       clk,    // Clock signal
    input  wire       rst,    // Active high synchronous reset
    output reg  [3:0] out     // 4-bit LFSR output
);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000; // Initialize to zero on reset
        else
            out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left with inverted XOR feedback
    end

endmodule