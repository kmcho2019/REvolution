module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out = in ^ out;
    wire gated_xor = clk ? xor_out : out;

    always @(posedge clk) begin
        out <= gated_xor;
    end

endmodule