module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    reg  [3:0] next_state;

    // Compute the feedback as inverted XOR of out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    // Next state computation combinationally
    always @(*) begin
        next_state = {out[2:0], feedback};
    end

    // Sequential update of out with reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;  // Initialize to non-zero to avoid lock-up
        else
            out <= next_state;
    end

endmodule