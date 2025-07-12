module LFSR #(
    parameter [3:0] SEED = 4'b1001  // Non-zero seed to avoid lock-up
)(
    input  wire       clk,
    input  wire       rst,     // synchronous active-high reset
    output reg  [3:0] out
);

    // Bit positions for feedback calculation
    localparam integer MSB = 3;
    localparam integer BIT2 = 2;

    // Feedback: inverted XOR of bits 3 and 2 of current state
    wire feedback = ~(out[MSB] ^ out[BIT2]);

    // Next state: left shift by one, insert feedback at LSB
    wire [3:0] next_state = {out[MSB-1:0], feedback};

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            out <= SEED;
        end else begin
            out <= next_state;
        end
    end

endmodule