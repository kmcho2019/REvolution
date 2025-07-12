module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
end

always @(posedge clk) begin
    if (prev_a == 1'b0 && a == 1'b1) begin
        q_reg <= 1'b0;
    end else if (prev_a == 1'bx || prev_a == 1'b0) begin
        q_reg <= 1'b1;
    end
end

assign q = q_reg;

endmodule