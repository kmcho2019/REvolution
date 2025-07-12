module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            // Initialize with a non-zero seed to avoid lock-up
            out <= 4'b1001;
        end else begin
            // Calculate feedback as inverted XOR of MSB and second MSB
            wire feedback = ~(out[3] ^ out[2]);
            // Shift right by 1 and insert feedback at MSB
            out <= {feedback, out[3:1]};
        end
    end

endmodule