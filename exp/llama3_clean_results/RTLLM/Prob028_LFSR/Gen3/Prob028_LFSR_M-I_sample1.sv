module LFSR #(
    parameter WIDTH = 4 // Parameter for the width of the LFSR
)(
    input clk,
    input rst,
    output [WIDTH-1:0] out
);

reg [WIDTH-1:0] state;
wire feedback;

// Calculate feedback based on the XOR of specific bits in the register
assign feedback = ~(state[WIDTH-1] ^ state[WIDTH-2]);

// Sequential logic for shifting and initialization
always_ff @ (posedge clk) begin
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