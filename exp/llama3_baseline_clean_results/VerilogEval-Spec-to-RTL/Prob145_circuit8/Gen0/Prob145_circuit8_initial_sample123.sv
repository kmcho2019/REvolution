module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg q_reg; // Register to hold the state of q

// Combinational logic for p: high when clock and a are high
assign p = a & clock;

// Sequential logic for q: uses a D flip-flop
always @(posedge clock) begin
    q_reg <= a; // Capture the state of a on the rising edge of clock
end

// Assign the output q from the register
assign q = q_reg;

endmodule