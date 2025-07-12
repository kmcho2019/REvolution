module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;
reg p_prev;

// Combinational output assignments
assign p = p_reg;
assign q = q_reg;

// Synchronous logic for p
always @(posedge clock) begin
    p_reg <= q_reg ? 1'b0 : a;
    p_prev <= p_reg;
end

// q logic with async clear and sync set
always @(posedge clock or posedge a) begin
    if (a && !clock) begin
        q_reg <= 1'b0;  // Async clear when a=1 during clock low
    end else if (p_prev) begin
        q_reg <= 1'b1;   // Sync set when previous p was 1
    end
end

initial begin
    p_reg = 1'b0;
    q_reg = 1'b0;
    p_prev = 1'b0;
end

endmodule