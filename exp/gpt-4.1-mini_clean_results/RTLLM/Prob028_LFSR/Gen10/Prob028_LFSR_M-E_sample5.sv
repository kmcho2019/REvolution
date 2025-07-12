module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    // Feedback is XOR of out[3] and out[2], no inversion
    assign feedback = out[3] ^ out[2];

    always @(posedge clk) begin
        if (rst)
            out <= 4'b1111;        // Initialize to non-zero state to avoid lock-up
        else
            out <= {out[2:0], feedback};
    end

endmodule