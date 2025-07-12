module TopModule (
    input clk,  // Clock signal
    input d,    // Input to D flip-flop
    output q    // Output of D flip-flop
);

reg q_reg;  // Internal register

// Update q_reg on the positive edge of the clock
always @(posedge clk) begin
    q_reg <= d;
end

// Continuously assign the value of q_reg to q
assign q = q_reg;

endmodule