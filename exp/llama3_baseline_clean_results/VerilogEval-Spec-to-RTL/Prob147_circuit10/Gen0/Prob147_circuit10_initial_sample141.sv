module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // register to store the state
assign state = state_reg; // assign the output state to the register

always @ (posedge clk) // trigger on the positive edge of the clock
begin
    if (~b && ~a) // if b and a are both low
        state_reg <= ~state_reg; // toggle the state
    else if (~b && a) // if b is low and a is high
        state_reg <= ~state_reg; // toggle the state
    else if (b && ~a) // if b is high and a is low
        state_reg <= state_reg; // keep the state the same
    else if (b && a) // if b and a are both high
        state_reg <= ~state_reg; // toggle the state
end

assign q = (state_reg && ~b) || (~state_reg && b); // assign the output q based on the current state and the input signals b

endmodule