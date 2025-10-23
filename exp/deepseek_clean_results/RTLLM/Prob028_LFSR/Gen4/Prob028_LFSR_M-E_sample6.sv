module LFSR (
    input wire clk,                // Clock
    input wire rst,                // Active-high synchronous reset
    input wire load,               // Parallel load control
    input wire [3:0] load_data,    // Parallel load data
    output reg [3:0] out,          // 4-bit LFSR state output
    output wire random_bit         // Single random bit output
);

// Configurable parameters
parameter SEED = 4'b0001;          // Initial seed value
parameter [3:0] TAPS = 4'b1100;    // Feedback taps (bits 3 and 2)
parameter INVERT_OUT = 1;          // Output inversion option

// Gray-coded state transition
reg [3:0] next_state;

// Feedback calculation using configurable taps
wire feedback = ^(out & TAPS);

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;               // Initialize with parameterized seed
    end
    else if (load) begin
        out <= load_data;         // Parallel load
    end
    else begin
        out <= next_state;        // Gray-coded transition
    end
end

// Gray coding for state transitions
always @(*) begin
    next_state = {out[2:0], feedback};
    if (INVERT_OUT) next_state = ~next_state;
end

// Optional random bit output
assign random_bit = out[3];

endmodule