module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg next_Q;

// Combinational logic for next state
always @(*) begin
    case ({j, k})
        2'b00: next_Q = Q;      // No change
        2'b01: next_Q = 1'b0;   // Reset
        2'b10: next_Q = 1'b1;   // Set
        2'b11: next_Q = ~Q;     // Toggle
        default: next_Q = Q;    // Default case for robustness
    endcase
end

// Sequential logic for state transition
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule