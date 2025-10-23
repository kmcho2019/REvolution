module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg q_reg;
reg state_reg;

always @(posedge clk) begin
    if (a && b) begin
        q_reg <= 0;
    end else if (b &&!state_reg) begin
        q_reg <= 1;
    end else if (!a &&!b) begin
        q_reg <= state_reg;
    end else begin
        q_reg <= state_reg;
    end
    
    state_reg <= q_reg;
end

assign q = q_reg;
assign state = state_reg;

initial begin
    q_reg = 0;
    state_reg = 0;
end

endmodule