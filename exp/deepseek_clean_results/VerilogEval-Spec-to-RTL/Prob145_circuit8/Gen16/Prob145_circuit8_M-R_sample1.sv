module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;
reg p_prev;

// Combinational logic for p
assign p = p_reg;

// Synchronous p update
always @(posedge clock) begin
    if (!q_reg) begin
        p_reg <= a;
    end else begin
        p_reg <= 0;
    end
    p_prev <= p_reg;
end

// q logic with async clear and sync set
always @(negedge clock or posedge a) begin
    if (a) begin
        q_reg <= 0;
    end else if (p_prev) begin
        q_reg <= 1;
    end
end

assign q = q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
    p_prev = 0;
end

endmodule