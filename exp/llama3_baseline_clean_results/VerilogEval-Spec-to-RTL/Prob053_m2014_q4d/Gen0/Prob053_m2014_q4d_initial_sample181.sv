module TopModule(
    input  clk,
    input  in,
    output reg out
);

    always_ff @(posedge clk) begin
        out <= in ^ out;
    end

endmodule