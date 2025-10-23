module LFSR (
    input wire clk,        // Clock
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // 4-bit LFSR state output
);

// Feedback calculation
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Next state calculation
wire [3:0] next_out;
assign next_out = rst ? 4'b0001 : {out[2:0], feedback};

// Register update (sequential logic without always block)
initial out = 4'b0001;
always @(posedge clk) out <= next_out;

endmodule