module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg, q_reg;

always @(posedge clock) begin
    p_reg <= a;
end

always @(negedge clock) begin
    if(p_reg) begin
        q_reg <= 1;
    end else begin
        q_reg <= q_reg;
    end
end

always @(posedge clock or negedge clock) begin
    if(posedge clock) begin
        // No action needed here since we only care about negedge for q
    end else if(negedge clock) begin
        // q already handled in its specific block
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule