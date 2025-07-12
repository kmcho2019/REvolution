module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    // Compute feedback as inverted XOR of bits 3 and 2
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001; // non-zero seed on reset to avoid all-zero lockup
        else
            out <= {feedback, out[3:1]}; // shift right, insert feedback at MSB
    end

endmodule