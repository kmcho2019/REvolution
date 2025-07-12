module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
reg first_transition;

initial begin
    q_reg = 1'b0;
    first_transition = 1'b1;
end

always @(posedge clk) begin
    if (a) begin
        if (first_transition) begin
            q_reg <= 1'b1;
            first_transition <= 1'b0;
        end else begin
            q_reg <= ~q_reg;
        end
    end
end

assign q = q_reg;

endmodule