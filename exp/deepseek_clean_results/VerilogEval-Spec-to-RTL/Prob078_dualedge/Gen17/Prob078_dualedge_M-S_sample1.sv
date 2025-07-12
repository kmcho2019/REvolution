module TopModule (
    input clk,
    input d,
    output q
);

    reg q_reg;

    always @(posedge clk or negedge clk) begin
        q_reg <= d;
    end

    assign q = q_reg;

endmodule