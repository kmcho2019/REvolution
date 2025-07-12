module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State transition: toggle when both inputs are high
always @(posedge clk) begin
    state_reg <= (a & b) ? ~state_reg : state_reg;
end

// Output logic:
// When state=0: q = a ^ b
// When state=1: q = a | b
assign q = state_reg ? (a | b) : (a ^ b);
assign state = state_reg;

endmodule