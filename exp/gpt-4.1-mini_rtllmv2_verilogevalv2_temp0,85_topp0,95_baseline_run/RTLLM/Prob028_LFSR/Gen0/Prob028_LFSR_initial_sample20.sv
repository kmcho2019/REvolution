module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            // Calculate feedback: inverted XOR of out[3] and out[2]
            wire feedback = ~(out[3] ^ out[2]);
            // Shift left and insert feedback at LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule