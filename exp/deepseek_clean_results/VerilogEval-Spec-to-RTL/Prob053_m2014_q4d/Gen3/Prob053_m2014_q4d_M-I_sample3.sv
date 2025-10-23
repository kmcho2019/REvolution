module TopModule (
    input clk,
    input in,
    output reg out = 0
);

    wire xor_out;
    assign xor_out = in ^ out;

    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule