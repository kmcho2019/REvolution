module LFSR (
    input wire clk,                // System clock
    input wire rst,                // Active-high reset
    input wire test_mode,          // Enters test mode when high
    input wire [3:0] output_mask,  // Selects which bits to output
    output reg [3:0] out,          // Masked LFSR output
    output wire sequence_ok        // Indicates correct test sequence
);

// Internal state registers
reg [3:0] state;
reg [1:0] tap_selector;
reg prev_parity;

// Gray-coded state transitions
wire [3:0] next_state_gray;

// Feedback calculation with rotating taps and parity
wire [1:0] current_taps = tap_selector[1] ? {state[3], state[1]} : {state[2], state[0]};
wire feedback = ^current_taps ^ prev_parity;
wire new_parity = ^state;

// Self-seeding logic - ensures state never stays at 0
wire [3:0] next_state = (state == 0) ? 4'b0001 : 
                       {state[2:0], feedback};

// Convert to gray code for low-power transitions
assign next_state_gray = next_state ^ {1'b0, next_state[3:1]};

// Test sequence checker (expects maximal length sequence)
reg [3:0] test_sequence [0:14];
initial begin
    test_sequence[0] = 4'b0001;
    test_sequence[1] = 4'b0010;
    test_sequence[2] = 4'b0100;
    test_sequence[3] = 4'b1000;
    test_sequence[4] = 4'b0011;
    test_sequence[5] = 4'b0110;
    test_sequence[6] = 4'b1100;
    test_sequence[7] = 4'b1011;
    test_sequence[8] = 4'b0101;
    test_sequence[9] = 4'b1010;
    test_sequence[10] = 4'b0111;
    test_sequence[11] = 4'b1110;
    test_sequence[12] = 4'b1111;
    test_sequence[13] = 4'b1101;
    test_sequence[14] = 4'b1001;
end

reg [3:0] test_counter;
wire test_match = (state == test_sequence[test_counter]);

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;
        tap_selector <= 2'b00;
        prev_parity <= 1'b0;
        test_counter <= 4'b0;
    end else begin
        // Update state with gray coding
        state <= next_state_gray;
        
        // Rotate taps and update parity
        tap_selector <= tap_selector + 1;
        prev_parity <= new_parity;
        
        // Update test counter in test mode
        if (test_mode) begin
            test_counter <= (test_counter == 14) ? 0 : test_counter + 1;
        end
    end
    
    // Apply output mask
    out <= state & output_mask;
end

assign sequence_ok = test_mode ? test_match : 1'b1;

endmodule