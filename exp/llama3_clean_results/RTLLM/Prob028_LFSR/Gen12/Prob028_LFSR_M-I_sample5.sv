module LFSR #(
    parameter LENGTH = 4,
    parameter TAPS = 3 // For a 4-bit LFSR with feedback from bit 3 and 2, TAPS should be adjusted accordingly
) (
    input clk,
    input rst,
    output reg [LENGTH-1:0] out
);

reg [LENGTH-1:0] state;

// Calculate feedback based on the polynomial taps
wire feedback;
assign feedback = state[LENGTH-1] ^ state[TAPS-1];

// Sequential logic for updating the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= {LENGTH{1'b0}}; // Initialize state to zero on reset
    end else begin
        // Shift left and insert feedback at LSB
        state <= {state[LENGTH-2:0], feedback};
    end
end

// Continuous assignment for output
assign out = state;

endmodule