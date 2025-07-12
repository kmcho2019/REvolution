module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg q_reg;

assign q = q_reg;
assign state = q_reg;

always @(posedge clk) begin
    if (b == 1'b1) begin
        q_reg <= a;
    end else begin
        q_reg <= q_reg;
    end
end

endmodule