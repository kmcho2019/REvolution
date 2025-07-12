module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;  // Initialize to zero on reset as specified
        else begin
            // feedback = inverted XOR of out[3] and out[2]
            wire feedback = ~(out[3] ^ out[2]);
            out <= {out[2:0], feedback};
        end
    end

endmodule