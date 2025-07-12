module LFSR #(
    parameter WIDTH = 4, // Parameter for the width of the LFSR
    parameter POLY_MSB = 3, // Polynomial for MSB calculation
    parameter POLY_2ND_MSB = 2 // Polynomial for 2nd MSB calculation
)(
    input clk,
    input rst,
    output [WIDTH-1:0] out
);

reg [WIDTH-1:0] state;
wire feedback;

// Calculate feedback based on the XOR of specific bits in the register
assign feedback = ~(state[POLY_MSB] ^ state[POLY_2ND_MSB]);

// Sequential logic for shifting and initialization
always @ (posedge clk) begin
    if (rst) begin
        state <= {WIDTH{1'b0}}; // Initialize register to zero on reset
    end else begin
        // Shift left and insert feedback
        state <= {state[WIDTH-2:0], feedback};
    end
end

// Continuous assignment for output
assign out = state;

endmodule