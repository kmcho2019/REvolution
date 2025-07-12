module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_ff, q_ff;

always @(posedge clock) begin
    // p flip-flop: set when a is high, cleared otherwise
    p_ff <= a;
    
    // q flip-flop: set when p was high in previous cycle
    q_ff <= p_ff;
end

assign p = p_ff;
assign q = q_ff;

endmodule