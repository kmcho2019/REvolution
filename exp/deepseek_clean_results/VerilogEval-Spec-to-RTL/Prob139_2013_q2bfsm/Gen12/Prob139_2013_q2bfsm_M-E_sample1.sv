module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Internal signals
reg [2:0] x_shift;      // Shift register for x sequence
reg [1:0] y_timeout;    // Timeout counter for y
reg f_pulse_done;       // Flag for f pulse completion
reg sequence_detected;  // Flag for 1-0-1 sequence
reg final_state;        // Flag for final state
reg y_success;          // Flag for y success

// Main state machine
always @(posedge clk) begin
    if (!resetn) begin
        // Reset all signals
        x_shift <= 3'b0;
        y_timeout <= 2'b0;
        f_pulse_done <= 1'b0;
        sequence_detected <= 1'b0;
        final_state <= 1'b0;
        y_success <= 1'b0;
    end
    else begin
        // Shift in new x value
        x_shift <= {x_shift[1:0], x};
        
        // Detect 1-0-1 sequence
        if (x_shift == 3'b101) begin
            sequence_detected <= 1'b1;
        end
        
        // Handle y monitoring phase
        if (sequence_detected && !final_state) begin
            if (y) begin
                y_success <= 1'b1;
                final_state <= 1'b1;
            end
            else if (y_timeout == 2'b10) begin
                final_state <= 1'b1;
            end
            else begin
                y_timeout <= y_timeout + 1;
            end
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
        f_pulse_done <= 1'b0;
    end
    else begin
        // Generate f pulse (one cycle after reset)
        if (!f_pulse_done) begin
            f <= 1'b1;
            f_pulse_done <= 1'b1;
        end
        else begin
            f <= 1'b0;
        end
        
        // Generate g output
        if (sequence_detected) begin
            if (!final_state) begin
                g <= 1'b1;  // Keep g high during monitoring
            end
            else begin
                g <= y_success;  // Permanent value based on y success
            end
        end
        else begin
            g <= 1'b0;
        end
    end
end

endmodule