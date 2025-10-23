module LFSR (
    input  wire       clk,
    input  wire       rst,    // Active high asynchronous reset
    output reg  [3:0] out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize to a non-zero seed to avoid lockup in all-zero state
            out <= 4'b0001;
        end else begin
            // Feedback is inverted XOR of MSB and second MSB bits
            // Shift left by one and insert feedback at LSB
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule