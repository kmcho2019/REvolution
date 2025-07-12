// Improved TopModule implementation
module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);
    reg internal_out = 1'b0;

    always @(posedge clk) begin
        internal_out <= in ^ out;
        out <= internal_out;
    end
endmodule