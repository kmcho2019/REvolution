module LFSR (
    input  wire       clk,
    input  wire       rst_n,  // active low asynchronous reset
    output reg  [3:0] out
);

    wire fb = ~(out[0] ^ out[1]);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 4'b1000;  // non-zero seed to avoid lockup
        else
            out <= {fb, out[3:1]}; // shift right, insert feedback at MSB
    end

endmodule