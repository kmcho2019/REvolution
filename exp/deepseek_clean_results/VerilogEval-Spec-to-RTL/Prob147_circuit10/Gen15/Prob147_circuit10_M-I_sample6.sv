module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;
wire q_comb;

always @(posedge clk) begin
    // State toggles only when both a and b are high
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Combinational logic for q
assign q_comb = (state_reg & b) |  // Case 1: state=1 and b=1
                (~a & b) |         // Case 2: a=0 and b=1
                (~a & ~b & state_reg); // Case 3: a=0, b=0, state=1

// Output assignments
assign q = q_comb;
assign state = state_reg;

endmodule