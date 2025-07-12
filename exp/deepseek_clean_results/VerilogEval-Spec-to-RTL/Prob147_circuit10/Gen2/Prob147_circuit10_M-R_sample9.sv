module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
wire next_state;

// Next state logic: toggle when (a&b) or set when (~a&b)
assign next_state = (a & b) ? ~state_reg : 
                   (~a & b) ? 1'b1 : state_reg;

// Output logic: q = (b ^ state) or (a & b)
assign q = (b ^ state_reg) | (a & b);

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule