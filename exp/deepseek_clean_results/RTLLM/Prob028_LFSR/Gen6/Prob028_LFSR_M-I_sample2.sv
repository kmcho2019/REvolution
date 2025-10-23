module LFSR #(
    parameter WIDTH = 4,                // Configurable width
    parameter SEED  = 4'b0001           // Configurable seed value
)(
    input wire clk,                     // Clock input
    input wire rst,                     // Active-high reset
    input wire en,                      // Clock enable
    output reg [WIDTH-1:0] out          // LFSR output
);

// Internal signals
wire feedback;
wire [WIDTH-1:0] next_out;

// Feedback polynomial: x^4 + x^3 + 1 (taps at bits 3 and 2)
assign feedback = out[WIDTH-1] ^ out[WIDTH-2];

// Next state calculation
assign next_out = {out[WIDTH-2:0], feedback};

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (rst) begin
        out <= SEED;                    // Initialize to seed value
    end
    else if (en) begin                  // Only update when enabled
        out <= next_out;
    end
end

endmodule