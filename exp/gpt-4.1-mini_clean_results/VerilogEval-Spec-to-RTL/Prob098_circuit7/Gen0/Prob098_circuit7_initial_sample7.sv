module TopModule(
    input clk,
    input a,
    output reg q
);

    reg a_reg;

    always @(posedge clk) begin
        a_reg <= a;
        q <= ~a_reg;
    end

endmodule