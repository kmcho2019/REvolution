module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    assign out = state;

    always @(posedge clk) begin
        state <= in ^ out;
    end

endmodule