module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_val;

    assign xor_val = in ^ out;

    always @(posedge clk) begin
        out <= xor_val;
    end

endmodule