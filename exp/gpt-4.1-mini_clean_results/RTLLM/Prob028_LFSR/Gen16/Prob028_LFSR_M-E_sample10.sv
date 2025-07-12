module LFSR(
    input  wire       clk,
    input  wire       rst,   // asynchronous active-high reset
    output reg  [3:0] out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b0000;  // reset register to zero immediately
        end else begin
            // Feedback is inverted XOR of bits 3 and 2
            // Compute feedback based on current out before shifting
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule