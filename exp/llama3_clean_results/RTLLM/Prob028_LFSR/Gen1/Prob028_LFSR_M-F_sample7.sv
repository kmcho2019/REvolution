module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;
wire feedback; // Explicit declaration of feedback as a wire

// Combinational logic for feedback calculation
assign feedback = ~(state[3] ^ state[2]); // Calculate feedback based on the current state

// Sequential logic for shifting and initialization
always @ (posedge clk) begin
    if (rst) begin
        state <= 4'b0; // Initialize register to zero on reset
    end else begin
        state <= {state[2:0], feedback}; // Shift left and insert feedback
    end
end

// Continuous assignment for output
assign out = state;

endmodule