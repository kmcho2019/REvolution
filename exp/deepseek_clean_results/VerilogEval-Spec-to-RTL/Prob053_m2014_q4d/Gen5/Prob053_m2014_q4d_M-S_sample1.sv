module TopModule (
    input clk,
    input in,
    output out
);

    reg out;

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule