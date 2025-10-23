module LFSR (
    input wire clk,                // Clock input
    input wire rst,                // Active-high synchronous reset
    input wire [1:0] poly_sel,     // Polynomial selection (00: x^4+x^3+1, 01: x^4+x^2+1, etc.)
    output reg [3:0] out,          // Current LFSR state
    output wire [15:0] parallel_out, // Next 4 states concatenated
    output wire stats_valid        // Statistical validity indicator
);

reg [3:0] state;
reg [3:0] next_state;
wire feedback;
reg [1:0] parity_counter;
wire all_zero = (state == 4'b0000);

// Configurable feedback polynomial
assign feedback = 
    (poly_sel == 2'b00) ? ~(state[3] ^ state[2]) :
    (poly_sel == 2'b01) ? ~(state[3] ^ state[1]) :
    (poly_sel == 2'b10) ? ~(state[3] ^ state[0]) :
                          ~(state[3] ^ state[2] ^ state[1] ^ state[0]);

// Next state calculation with self-seeding
always @(*) begin
    if (all_zero) begin
        next_state = 4'b0001;  // Auto-seed if stuck at zero
    end else begin
        next_state = {state[2:0], feedback};
    end
end

// State update and parallel output calculation
always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;
        parity_counter <= 2'b00;
    end else begin
        state <= next_state;
        // Simple running parity check (mod 4)
        parity_counter <= parity_counter + ^{next_state};
    end
end

// Generate parallel output (next 4 states)
assign parallel_out = {
    next_state,                         // State 1
    {next_state[2:0], ~(next_state[3] ^ next_state[2])},  // State 2
    {next_state[1:0], ~(next_state[3] ^ next_state[2]),   // State 3
           ~(next_state[3] ^ next_state[2])};             // State 4

// Statistical validity check (simple parity balance)
assign stats_valid = (parity_counter != 2'b11);

assign out = state;

endmodule