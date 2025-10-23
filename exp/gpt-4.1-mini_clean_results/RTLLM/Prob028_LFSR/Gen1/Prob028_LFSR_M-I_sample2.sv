module LFSR #(
    parameter [3:0] SEED = 4'b0001  // Non-zero initial seed to avoid lock-up at zero
) (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= SEED;  // Initialize to non-zero seed
        else
            out <= {out[2:0], feedback};
    end

endmodule