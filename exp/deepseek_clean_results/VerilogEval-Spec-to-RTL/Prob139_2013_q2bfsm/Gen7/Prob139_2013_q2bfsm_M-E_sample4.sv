module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] x_history;  // Tracks last 3 x values
reg [1:0] y_timer;    // Counts cycles in y monitoring phase
reg sequence_matched; // Flag when 1-0-1 sequence detected
reg output_locked;    // Flag when g output is permanently set
reg f_pulse_done;     // Flag when f pulse has occurred

always @(posedge clk) begin
    if (!resetn) begin
        // Reset all registers
        x_history <= 3'b000;
        y_timer <= 2'b00;
        sequence_matched <= 1'b0;
        output_locked <= 1'b0;
        f_pulse_done <= 1'b0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // Shift in new x value
        x_history <= {x_history[1:0], x};
        
        // Handle f pulse (one cycle after reset deassertion)
        if (!f_pulse_done) begin
            f <= 1'b1;
            f_pulse_done <= 1'b1;
        end else begin
            f <= 1'b0;
        end

        // Sequence detection and y monitoring
        if (!output_locked) begin
            // Check for 1-0-1 pattern
            if (x_history == 3'b101) begin
                sequence_matched <= 1'b1;
                g <= 1'b1;
                y_timer <= 2'b00;
            end
            
            // If sequence matched, monitor y
            if (sequence_matched) begin
                y_timer <= y_timer + 1;
                
                // Check y within 2 cycles
                if (y) begin
                    output_locked <= 1'b1;  // Lock g permanently high
                end else if (y_timer == 2'b10) begin
                    g <= 1'b0;
                    output_locked <= 1'b1;  // Lock g permanently low
                end
            end
        end
    end
end

endmodule