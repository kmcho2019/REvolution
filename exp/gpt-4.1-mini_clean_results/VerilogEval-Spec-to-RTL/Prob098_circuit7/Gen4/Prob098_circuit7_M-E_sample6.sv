module TopModule (
    input clk,
    input a,
    output q
);
    reg a_reg;

    always @(posedge clk) begin
        a_reg <= a;
    end

    assign q = ~a_reg;

endmodule