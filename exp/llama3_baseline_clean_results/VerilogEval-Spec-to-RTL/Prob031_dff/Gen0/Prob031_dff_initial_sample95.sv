module TopModule(clk, d, q);
    input clk;
    input d;
    input q;

    reg q_reg;

    initial q_reg = q;

    always @(posedge clk) begin
        q_reg <= d;
    end

    assign q = q_reg;
endmodule