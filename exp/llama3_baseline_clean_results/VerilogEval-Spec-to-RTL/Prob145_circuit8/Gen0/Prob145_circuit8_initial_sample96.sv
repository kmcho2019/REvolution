module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg state_p; // internal state for p

always @(posedge clock) begin
    state_p <= a; // update state_p when clock is high
end

assign p = state_p; // assign output p to the state_p
assign q = state_p; // assign output q to the state_p

endmodule