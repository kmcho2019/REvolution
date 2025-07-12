module LFSR #(
    parameter WIDTH = 4,
    parameter SEED  = 4'b0001  // Non-zero seed to avoid lock state
) (
    input  wire             clk,
    input  wire             rst,
    output reg  [WIDTH-1:0] out
);

    // Feedback: inverted XOR of out[3] and out[2] as per specification
    wire feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

    always @(posedge clk) begin
        if (rst)
            out <= SEED;
        else
            out <= {out[WIDTH-2:0], feedback};
    end

endmodule