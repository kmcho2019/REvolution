module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b0001; // non-zero seed to prevent lock-up
        else begin
            // feedback is XOR of out[3] and out[2]
            // shift left and insert feedback at LSB
            out <= {out[2:0], out[3] ^ out[2]};
        end
    end

endmodule