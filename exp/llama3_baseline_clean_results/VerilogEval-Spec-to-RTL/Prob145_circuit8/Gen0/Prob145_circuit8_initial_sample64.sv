module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg; // register to hold the value of p
reg q_reg; // register to hold the value of q

// D flip-flop for p
always @(posedge clock) begin
    p_reg <= a;
end

// D flip-flop for q
always @(posedge clock) begin
    q_reg <= p_reg;
end

// assign outputs
assign p = p_reg;
assign q = q_reg;

// initial values
initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule