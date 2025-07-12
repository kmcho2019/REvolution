module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // Register to hold the current state
assign state = state_reg; // Assign the current state to the output

always @(posedge clk) begin
    if (a == 0 && b == 0 || a == 1 && b == 1) begin
        state_reg <= a;
    end
end

assign q = (state_reg == 0) ? b : ~b;

endmodule