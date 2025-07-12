module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            // Load a non-zero seed to avoid lock-up state
            out <= 4'b1000;
        end else begin
            // Compute feedback as inverted XOR of out[0] and out[1]
            wire fb = ~(out[0] ^ out[1]);
            // Shift right and insert feedback at MSB
            out <= {fb, out[3:1]};
        end
    end

endmodule