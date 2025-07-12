module LFSR (
    input clk,
    input rst,
    input en,
    input [3:0] seed,
    output [3:0] out
);

reg [3:0] state;
wire feedback;

// Galois configuration with taps at bits 1 and 4 (x^4 + x + 1)
assign feedback = state[0];
assign out = state; // Parallel output

always @(posedge clk) begin
    if (rst) begin
        state <= seed; // Programmable initialization
    end
    else if (en) begin
        state <= {feedback, state[3:1] ^ {3{feedback}} & 3'b001};
        // Simultaneous shift and XOR operations
    end
end

endmodule