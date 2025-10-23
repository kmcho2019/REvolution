module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // register to store the state
assign state = state_reg; // output the state

always @(posedge clk) // sequential logic at positive edge of clock
begin
    if (a == 1'b1 && state_reg == 1'b0) // if a is high and state is 0
        state_reg <= 1'b1; // set state to 1
    else if (a == 1'b0 && state_reg == 1'b1) // if a is low and state is 1
        state_reg <= 1'b0; // set state to 0
end

assign q = (b == 1'b1) ? ~state_reg : (state_reg == 1'b0) ? a : ~a; // combinational logic to generate output q

endmodule