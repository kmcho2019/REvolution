module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg = 0; // Initialize p to 0
reg q_reg = 0; // Initialize q to 0

always @(posedge clock) begin
    if (a == 1) begin
        p_reg <= 1;
    end else begin
        p_reg <= 0;
    end
end

always @(negedge clock) begin
    if (p_reg == 1) begin
        q_reg <= 1;
    end
end

always @(posedge clock) begin
    if (a == 0) begin
        if (q_reg == 1 && p_reg == 0) begin
            q_reg <= 0;
        end
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule