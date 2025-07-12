module LFSR (
    input wire clk,                // Clock input
    input wire rst,                // Active-high synchronous reset
    input wire direction,          // 0=right shift, 1=left shift
    input wire [1:0] mode,         // Operation mode selector
    input wire [3:0] seq_length,   // Sequence length before auto-reset
    output reg [3:0] out,          // Current LFSR state
    output wire seq_end            // Pulse when sequence completes
);

reg [3:0] state;
reg [3:0] counter;
wire [3:0] next_state;
wire feedback_left, feedback_right;

// Hybrid feedback network - weighted combination of 3 polynomials
assign feedback_left = 
    (mode == 2'b00) ? state[0] ^ state[3] :
    (mode == 2'b01) ? state[1] ^ state[2] ^ state[3] :
    (mode == 2'b10) ? (state[0] & state[1]) ^ state[3] :
                      (state[0] | state[1]) ^ state[2];

assign feedback_right = 
    (mode == 2'b00) ? state[3] ^ state[0] :
    (mode == 2'b01) ? state[2] ^ state[1] ^ state[0] :
    (mode == 2'b10) ? (state[3] & state[2]) ^ state[0] :
                      (state[3] | state[2]) ^ state[1];

// State-dependent behavior - changes shift direction when in state 4'b1010
wire actual_direction = (state == 4'b1010) ? ~direction : direction;

// Next state calculation
assign next_state = actual_direction ? 
    {state[2:0], feedback_left} :  // Left shift
    {feedback_right, state[3:1]};  // Right shift

// Sequence counter and end detection
assign seq_end = (counter == seq_length);

always @(posedge clk) begin
    if (rst || seq_end) begin
        state <= 4'b0001;          // Initial state (non-zero)
        counter <= 4'b0000;
    end else begin
        state <= next_state;
        counter <= counter + 1;
    end
end

// Output assignments
always @(*) begin
    out = state;
    // State-dependent output transformation
    if (state[3] ^ state[0]) begin
        out = {state[2:0], state[3]};  // Rotate right when XOR is true
    end
end

endmodule