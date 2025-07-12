module LFSR #(
    parameter [3:0] SEED = 4'b0001  // Non-zero initial seed to avoid lock-up at zero
) (
    input  wire       clk,
    input  wire       rst,
    output reg [3:0]  out
);

    // Function to compute feedback as inverted XOR of out[3] and out[2]
    function automatic logic feedback_fn(input [3:0] state);
        feedback_fn = ~(state[3] ^ state[2]);
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            out <= SEED;
        end else begin
            // Shift left by one and insert computed feedback at LSB
            out <= {out[2:0], feedback_fn(out)};
        end
    end

endmodule