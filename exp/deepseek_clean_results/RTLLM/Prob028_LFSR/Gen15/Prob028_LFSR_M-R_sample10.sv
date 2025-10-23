module LFSR (
    input wire clk,
    input wire rst,
    output wire [3:0] out
);

// Internal signals
wire [3:0] next_state;
wire feedback;
reg [3:0] state_reg;

// Feedback calculation (inverted XOR of bits 3 and 2)
assign feedback = ~(state_reg[3] ^ state_reg[2]);

// Next state logic (shift left + feedback)
assign next_state = rst ? 4'b0001 : {state_reg[2:0], feedback};

// State register (D-flipflop implementation)
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output assignment
assign out = state_reg;

endmodule