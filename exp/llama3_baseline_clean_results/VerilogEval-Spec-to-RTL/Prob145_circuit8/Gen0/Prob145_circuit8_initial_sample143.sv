module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
end

always @(posedge clock) begin
    if (a == 1'b1) begin
        p_reg <= 1'b1;
    end else begin
        p_reg <= 1'b0;
    end
end

always @(posedge clock or negedge clock) begin
    if (clock == 1'b1) begin
        if (a == 1'b1) begin
            q_reg <= 1'b1;
        end
    end else if (p_reg == 1'b1) begin
        q_reg <= 1'b1;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule