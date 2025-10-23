module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
wire p_comb = clock & a;
reg prev_a;

always @(negedge clock) begin
    prev_a <= a;
    
    // Reset condition: a rising edge during low clock
    if (a && !prev_a) begin
        q_reg <= 1'b0;
    end
    // Toggle q when p is high during low clock phase
    else if (p_comb) begin
        q_reg <= ~q_reg;
    end
end

assign p = p_comb;
assign q = q_reg;

endmodule