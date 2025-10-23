module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] x_shift;       // Shift register for x pattern
    reg f_pulsed;            // Flag for initial f pulse
    reg pattern_matched;     // Flag for 1-0-1 pattern
    reg [1:0] y_timer;       // Timer for y monitoring
    reg y_timeout;           // Flag for y timeout
    reg y_detected;          // Flag for y detection

    always @(posedge clk) begin
        if (!resetn) begin
            // Reset all registers
            x_shift <= 3'b000;
            f_pulsed <= 1'b0;
            pattern_matched <= 1'b0;
            y_timer <= 2'b00;
            y_timeout <= 1'b0;
            y_detected <= 1'b0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            // Always shift in new x value
            x_shift <= {x_shift[1:0], x};
            
            // Check for 1-0-1 pattern continuously
            if (x_shift == 3'b101) begin
                pattern_matched <= 1'b1;
            end
            
            // Initial f pulse logic
            if (!f_pulsed) begin
                f <= 1'b1;
                f_pulsed <= 1'b1;
            end else begin
                f <= 1'b0;
            end
            
            // y monitoring logic
            if (pattern_matched && !y_detected && !y_timeout) begin
                if (y) begin
                    y_detected <= 1'b1;
                end else if (y_timer == 2'b10) begin
                    y_timeout <= 1'b1;
                end else begin
                    y_timer <= y_timer + 1'b1;
                end
            end
            
            // Output g logic
            if (pattern_matched) begin
                if (y_detected) begin
                    g <= 1'b1;
                end else if (y_timeout) begin
                    g <= 1'b0;
                end else begin
                    g <= 1'b1;  // Maintain g=1 while monitoring y
                end
            end else begin
                g <= 1'b0;
            end
        end
    end

endmodule