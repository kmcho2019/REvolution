module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;
reg reset_flag;

// Capture reset condition on negedge clock
always @(negedge clock) begin
    reset_flag <= a;
end

// Main sequential logic
always @(posedge clock) begin
    if (reset_flag) begin
        p_reg <= 0;
        q_reg <= 0;
    end
    else begin
        q_reg <= p_reg;  // q follows p with one cycle delay
        p_reg <= q_reg ? 0 : a;  // p follows a only when q is 0
    end
end

// Continuous assignments for outputs
assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
    reset_flag = 0;
end

endmodule