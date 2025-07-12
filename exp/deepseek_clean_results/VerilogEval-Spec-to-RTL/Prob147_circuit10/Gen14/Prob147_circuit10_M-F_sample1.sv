module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State transition logic - toggle only when both a and b are high
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - follows b when state=0, inverted b when state=1
assign q = state_reg ? ~b : b;
assign state = state_reg;

endmodule