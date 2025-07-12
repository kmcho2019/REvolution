module TopModule(
    input clk,
    input a,
    output q
);
reg q_reg;
initial q_reg = 1'b0; // Initialize q_reg to 0

always @(posedge clk) begin
    if(a == 1'b0 && q_reg == 1'b0) begin
        q_reg <= 1'b1;
    end else if(a == 1'b1) begin
        q_reg <= ~q_reg;
    end
end

assign q = q_reg;

endmodule