module LFSR (
    input clk,
    input rst,
    input load_en,      // New: Load enable control
    output reg [3:0] out
);

// Configurable feedback taps (default to bits 3 and 2)
parameter TAP1 = 3;
parameter TAP2 = 2;

// Internal next state calculation
wire [3:0] next_state;

// Feedback calculation (XOR of selected taps, then inverted)
assign next_state = {out[2:0], ~(out[TAP1] ^ out[TAP2])};

// Parallel load operation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;  // Active high reset
    end else if (load_en) begin
        out <= next_state;  // Parallel load of new state
    end
    // Otherwise maintains current state
end

endmodule