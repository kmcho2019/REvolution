module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire fb = ~(out[3] ^ out[2]);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {fb, out[3:1]};
    end

endmodule