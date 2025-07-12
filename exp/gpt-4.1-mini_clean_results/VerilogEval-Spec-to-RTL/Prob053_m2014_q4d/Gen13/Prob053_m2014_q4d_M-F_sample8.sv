module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_result;

    assign xor_result = in ^ out;

    always @(posedge clk) begin
        out <= xor_result;
    end

endmodule