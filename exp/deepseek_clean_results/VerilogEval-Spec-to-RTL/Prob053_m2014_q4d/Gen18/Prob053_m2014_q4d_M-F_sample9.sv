module TopModule (
    input clk,
    input in,
    output reg out
);

    wire feedback_xor;
    assign feedback_xor = in ^ out;

    always @(posedge clk) begin
        out <= feedback_xor;
    end

endmodule