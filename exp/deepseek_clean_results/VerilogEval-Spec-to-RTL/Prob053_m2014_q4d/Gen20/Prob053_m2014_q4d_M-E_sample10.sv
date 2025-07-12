module TopModule (
    input clk,
    input in,
    output reg out
);

    wire dynamic_xor = in ^ out;
    wire gated_xor = clk ? dynamic_xor : out;

    always @(posedge clk) begin
        out <= gated_xor;
    end

endmodule