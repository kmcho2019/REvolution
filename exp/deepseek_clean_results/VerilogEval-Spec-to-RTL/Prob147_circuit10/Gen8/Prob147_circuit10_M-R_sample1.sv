module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State updates on clock edge when inputs differ
always @(posedge clk) begin
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic: q = state ? (a ^ b) : b
assign q = state_reg ? (a ^ b) : b;
assign state = state_reg;

endmodule