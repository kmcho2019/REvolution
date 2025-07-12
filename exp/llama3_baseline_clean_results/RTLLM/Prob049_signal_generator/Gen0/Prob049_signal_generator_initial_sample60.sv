module signal_generator (
    input  clk,        // Clock signal
    input  rst_n,      // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

// Register declaration for state and waveform
reg [0:0] state;      // 1-bit state register
reg [4:0] wave;       // 5-bit waveform register

// Initial block to set default values (optional, not synthesizable)
initial begin
    state = 0;         // Initialize state to 0
    wave  = 0;         // Initialize waveform to 0
end

// Always block triggered on the positive edge of the clock or the negative edge of the reset
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;    // Clear state to 0
        wave  <= 0;    // Clear waveform to 0
    end else begin    // Normal operation
        case (state)
            0: begin  // Incrementing state
                if (wave == 5'd31) begin  // Check if waveform reached 31
                    state <= 1;          // Transition to decrementing state
                end
                wave  <= wave + 1;        // Increment waveform
            end
            1: begin  // Decrementing state
                if (wave == 5'd0) begin   // Check if waveform reached 0
                    state <= 0;           // Transition back to incrementing state
                end
                wave  <= wave - 1;        // Decrement waveform
            end
            default: begin
                state <= 0;                // Default to incrementing state
                wave  <= 0;                 // Default waveform to 0
            end
        endcase
    end
end

endmodule