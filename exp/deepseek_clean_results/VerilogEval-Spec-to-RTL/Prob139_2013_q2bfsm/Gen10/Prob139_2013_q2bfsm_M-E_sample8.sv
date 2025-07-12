module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Sequence detection counters
reg [1:0] seq_counter;  // Tracks 1-0-1 sequence progress (0-3)
reg [1:0] y_timeout;    // Tracks y detection window (0-2)
reg f_pulse;            // One-cycle pulse for f
reg g_latch;            // Permanent g value
reg g_active;           // Temporary g activation

// f output is just the pulse signal
assign f = f_pulse;

// g output is either the latched value or temporary active state
assign g = g_latch || g_active;

always @(posedge clk) begin
    if (!resetn) begin
        // Reset all counters and outputs
        seq_counter <= 0;
        y_timeout <= 0;
        f_pulse <= 0;
        g_latch <= 0;
        g_active <= 0;
    end else begin
        // Default f_pulse to 0 (single cycle)
        f_pulse <= 0;

        // Generate f pulse one cycle after reset
        if (seq_counter == 0 && y_timeout == 0 && !f_pulse && !g_latch) begin
            f_pulse <= 1;
        end

        // Sequence detection for 1-0-1 pattern
        if (!g_latch) begin
            case (seq_counter)
                0: if (x) seq_counter <= 1;  // First 1 detected
                1: seq_counter <= x ? 1 : 2; // Wait for 0
                2: if (x) seq_counter <= 3;  // Second 1 detected
                default: seq_counter <= seq_counter;
            endcase
        end

        // When sequence complete, activate g and start y detection
        if (seq_counter == 3 && !g_latch) begin
            g_active <= 1;
            y_timeout <= 1;  // Start 2-cycle timeout
        end

        // y detection during active g period
        if (g_active) begin
            if (y) begin
                // y detected - latch g permanently
                g_latch <= 1;
                g_active <= 0;
            end else if (y_timeout == 2) begin
                // Timeout expired - deactivate g
                g_active <= 0;
            end else begin
                // Increment timeout counter
                y_timeout <= y_timeout + 1;
            end
        end
    end
end

endmodule