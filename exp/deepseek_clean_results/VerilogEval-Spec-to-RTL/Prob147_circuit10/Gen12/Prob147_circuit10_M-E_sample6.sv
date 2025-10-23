module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State transition logic - toggle when both inputs are high
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - AND when state=0, OR when state=1
assign q = state_reg ? (a | b) : (a & b);
assign state = state_reg;

endmodule