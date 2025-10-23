module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

// p updates at rising edge:
// if q=1 then p = a else p holds 0 (or previous p if q=0, but waveform suggests 0)
always @(posedge clock) begin
    if (q_reg)
        p_reg <= a;
    else
        p_reg <= 1'b0;
end

// q updates at falling edge, q <= p
always @(negedge clock) begin
    q_reg <= p_reg;
end

assign p = p_reg;
assign q = q_reg;

endmodule