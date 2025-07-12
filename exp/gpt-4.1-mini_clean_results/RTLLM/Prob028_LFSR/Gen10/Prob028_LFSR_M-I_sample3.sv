module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire fb = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001; // Initialize to non-zero seed to avoid lockup
        else
            out <= {out[2:0], fb};
    end

endmodule