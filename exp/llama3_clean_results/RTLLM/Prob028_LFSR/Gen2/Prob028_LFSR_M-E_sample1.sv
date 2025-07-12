module LFSR #(
    parameter WIDTH = 4
)(
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

reg [WIDTH-1:0] state;

// Feedback calculation
wire feedback = ~(state[WIDTH-1] ^ state[WIDTH-2]);

// Sequential logic for shifting and feedback insertion
always @ (posedge clk) begin
    if (rst) begin
        state <= {WIDTH{1'b0}}; // Initialize register to zero on reset
    end else begin
        state <= {state[WIDTH-2:0], feedback}; // Shift left and insert feedback
    end
end

// Directly assign the state to the output
assign out = state;

endmodule