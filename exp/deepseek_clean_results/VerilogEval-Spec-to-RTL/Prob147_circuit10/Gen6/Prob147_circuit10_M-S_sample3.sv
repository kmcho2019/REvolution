module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Simplified state update - toggle when a=1
always @(posedge clk) begin
    if (a) begin
        state_reg <= ~state_reg;
    end
end

// Simplified output logic - just XOR
assign q = state_reg ^ b;
assign state = state_reg;

endmodule