module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
wire a_xor_b = a ^ b;

// Optimized state transition logic
always @(posedge clk) begin
    if (a & b)         // Set condition
        state_reg <= 1'b1;
    else if (~a & ~b)  // Reset condition
        state_reg <= 1'b0;
end

// Optimized output logic using shared XOR
assign q = state_reg ? ~a_xor_b : a_xor_b;
assign state = state_reg;

endmodule