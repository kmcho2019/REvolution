module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg a_prev;
reg p_reg;
reg q_reg;

always @(posedge clock) begin
    a_prev <= a;  // Store previous value of a for edge detection
    p_reg <= (a && !a_prev) ? 1'b1 : 1'b0;  // Set p on rising edge of a
    q_reg <= p_reg;  // q follows p with one cycle delay
end

assign p = p_reg;
assign q = q_reg;

endmodule