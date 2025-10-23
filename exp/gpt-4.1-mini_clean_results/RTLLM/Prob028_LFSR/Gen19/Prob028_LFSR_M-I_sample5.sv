module LFSR #(
    parameter [3:0] INITIAL_SEED = 4'b1001
) (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst)
            out <= INITIAL_SEED;  // parameterized non-zero seed
        else begin
            // Calculate feedback as inverted XOR of out[3] and out[2]
            // Shift left and insert feedback at LSB
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule