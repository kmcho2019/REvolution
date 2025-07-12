module LFSR (
    input wire clk,            // Clock signal
    input wire rst,            // Active high reset
    output reg [3:0] out,      // 4-bit LFSR state
    output wire seq_error      // Sequence error detection
);

// Internal signals
reg [3:0] next_state;
reg [3:0] prev_state;
reg [15:0] state_counter;     // Tracks unique states
wire feedback;
wire enhanced_feedback;

// Clock divider for adjustable rate
reg [3:0] clk_div = 0;
wire lfsr_clock = clk_div[3]; // Divide by 16
always @(posedge clk) clk_div <= clk_div + 1;

// Feedback as specified: XOR bits 3 and 2, then invert
assign feedback = ~(out[3] ^ out[2]);

// Enhanced feedback with previous state mixing
assign enhanced_feedback = feedback ^ prev_state[1];

// Next state calculation
always @(*) begin
    next_state = {out[2:0], enhanced_feedback};
end

// Sequence monitoring and update
always @(posedge lfsr_clock or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;       // Initialize to zero as specified
        prev_state <= 4'b0000;
        state_counter <= 0;
    end else begin
        prev_state <= out;
        out <= next_state;
        
        // Detect if we've seen this state before
        if (state_counter != 16'hFFFF) begin
            state_counter <= state_counter + 1;
        end
    end
end

// Sequence error detection (short cycle)
assign seq_error = (state_counter < 15 && state_counter > 0 && out == 4'b0000);

endmodule