module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output q     // Output of the D flip-flop
);

reg q_reg;  // Internal register to hold the state of the flip-flop
assign q = q_reg;  // Continuous assignment to output the state

always @ (posedge clk) begin
    // On the positive edge of the clock, update the internal state with the input data
    q_reg <= d;
end

endmodule