module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg; // internal register for q
assign p = (clock == 1)? a : 0; // assign p when clock is high
assign q = q_reg; // assign q from internal register

initial q_reg = 0; // initialize q_reg to 0

always @(posedge clock) // update q_reg on rising edge of clock
begin
    if(a == 1)
        q_reg = ~q_reg; // toggle q_reg when a is high
end

endmodule