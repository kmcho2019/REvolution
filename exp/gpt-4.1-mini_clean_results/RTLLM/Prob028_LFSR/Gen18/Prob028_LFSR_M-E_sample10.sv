module LFSR(
    input  wire       clk,
    input  wire       rst_n,  // asynchronous active-low reset
    output reg  [3:0] out
);

    wire feedback = out[3] ^ out[2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b1111;  // non-zero initial state to avoid lock-up
        end else begin
            // shift right, insert feedback at MSB
            out <= {feedback, out[3:1]};
        end
    end

endmodule