module TopModule (
    input clk,
    input in,
    output reg out
);

    // Intermediate XOR result
    wire feedback_xor = in ^ out;

    // Sequential block
    always @(posedge clk) begin
        out <= feedback_xor;
    end

endmodule