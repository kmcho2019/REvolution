module TopModule (
    input clk,
    input in,
    output reg out
);

    wire toggle_enable = in ^ out;

    always @(posedge clk) begin
        if (toggle_enable) begin
            out <= ~out;
        end
    end

endmodule