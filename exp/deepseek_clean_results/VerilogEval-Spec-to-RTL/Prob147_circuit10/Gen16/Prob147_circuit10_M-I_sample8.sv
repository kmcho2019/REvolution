module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Optimized state transition logic
always @(posedge clk) begin
    state_reg <= (a == b) ? ~state_reg : state_reg;
end

// Optimized output logic using mux structure
assign q = state_reg ? ~(a ^ b) : (a ^ b);
assign state = state_reg;

endmodule