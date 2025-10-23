module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

reg next_Q; // Signal to hold the next state of Q

// Combinational logic to determine the next state of Q
assign next_Q = (j & ~k) ? 1'b1 : 
                 (~j & k) ? 1'b0 : 
                 (j & k) ? ~Q : Q;

// Sequential logic to update Q at the positive edge of clk
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule