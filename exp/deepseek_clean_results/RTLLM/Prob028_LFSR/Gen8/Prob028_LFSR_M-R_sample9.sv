module LFSR (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    output wire [3:0] out      // Current LFSR state
);

// Next state calculation
wire [3:0] next_out;
wire feedback;

// Feedback calculation: XOR of bits 3 and 2, then inverted
assign feedback = ~(out[3] ^ out[2]);

// Next state is shift left with feedback at LSB
assign next_out = rst ? 4'b0000 : {out[2:0], feedback};

// State register
reg [3:0] state_reg;
always @(posedge clk) begin
    state_reg <= next_out;
end

// Output assignment
assign out = state_reg;

// Initialize for simulation
initial begin
    state_reg = 4'b0000;
end

endmodule