module LFSR (
    input wire clk,            // Clock
    input wire rst,            // Active-high synchronous reset
    input wire en,             // Enable signal
    input wire load,           // Parallel load enable
    input wire [3:0] seed,     // Initial seed value
    output wire [3:0] out      // Current LFSR state
);

// Configurable feedback taps (default: x^4 + x^3 + x^2 + x + 1)
parameter TAP3 = 1;  // x^4 term
parameter TAP2 = 1;  // x^3 term
parameter TAP1 = 1;  // x^2 term
parameter TAP0 = 1;  // x^1 term

reg [3:0] current_state;
wire [3:0] next_state;

// Feedback calculation using configurable taps
assign next_state = load ? seed : 
                   {current_state[2:0], 
                    ^(current_state & {TAP3, TAP2, TAP1, TAP0})};

// Current state register
always @(posedge clk) begin
    if (rst) begin
        current_state <= 4'b0001;  // Default reset state
    end
    else if (en) begin
        current_state <= next_state;
    end
end

assign out = current_state;

endmodule