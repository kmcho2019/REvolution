module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Feedback is inverted XOR of the two most significant bits
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;          // Non-zero initial state to avoid lock-up
        else
            out <= {out[2:0], feedback};
    end

    // Optional initial block for simulation purpose only
    // initial begin
    //     out = 4'b0001;
    // end

endmodule