module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0; // explicit initialization to zero

    always @(posedge clk) begin
        state <= in ^ state;
    end

    assign out = state;

endmodule