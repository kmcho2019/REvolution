module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg q_reg;

always @(posedge clk) begin
    if (b == 1) begin
        if (a == 0) begin
            q_reg <= 1;
        end else if (a == 1) begin
            q_reg <= 0;
        end
    end
end

assign q = q_reg;
assign state = q_reg;

endmodule