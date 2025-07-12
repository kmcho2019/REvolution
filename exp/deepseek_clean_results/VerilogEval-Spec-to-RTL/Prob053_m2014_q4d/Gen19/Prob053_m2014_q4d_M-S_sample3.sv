module TopModule (
    input clk,
    input in,
    output out
);

    reg d_reg;

    assign out = d_reg;

    always @(posedge clk) begin
        d_reg <= in ^ d_reg;
    end

endmodule