module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

// Combinational logic for feedback calculation
assign feedback = ~(out[3] ^ out[2]);

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