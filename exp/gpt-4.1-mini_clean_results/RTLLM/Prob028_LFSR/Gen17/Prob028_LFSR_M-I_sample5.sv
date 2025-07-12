module LFSR(
    input  wire       clk,
    input  wire       rst,  // synchronous active-high reset
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0001;  // initialize to a non-zero state to start sequence
        end else begin
            // feedback is inverted XOR of bits 3 and 2 of current state
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule