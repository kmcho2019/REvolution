module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback = ~(out[1] ^ out[0]);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b1111;
        else
            out <= {feedback, out[3:1]};
    end

endmodule