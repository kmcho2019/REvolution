module LFSR #(
    parameter [3:0] SEED = 4'b1001  // Parameterized non-zero seed to avoid lock-up
)(
    input  wire       clk,
    input  wire       rst,   // synchronous active-high reset
    output reg  [3:0] out
);

    // Combinational feedback calculation: inverted XOR of bits 3 and 2 of current state
    wire feedback = ~(out[3] ^ out[2]);

    // Combinational next state: left shift by one, insert feedback at LSB
    wire [3:0] next_state = {out[2:0], feedback};

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            out <= SEED;
        end else begin
            out <= next_state;
        end
    end

endmodule