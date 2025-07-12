module TopModule (
    input clk,
    input a,
    output q
);
    reg q_reg;

    always @(posedge clk) begin
        q_reg <= a;
    end

    // output is inverted version of the registered a
    assign q = ~q_reg;
endmodule