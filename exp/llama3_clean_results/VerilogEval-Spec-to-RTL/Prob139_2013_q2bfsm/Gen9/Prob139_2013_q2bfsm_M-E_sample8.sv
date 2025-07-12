module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_seq; // Shift register to hold last two values of x
reg seq_detected; // Flag to indicate sequence detection
reg [1:0] y_timer; // Timer to count cycles after sequence detection
reg y_seen; // Flag to indicate y has been seen

always @ (posedge clk) begin
    if (!resetn) begin
        x_seq <= 0;
        seq_detected <= 0;
        y_timer <= 0;
        y_seen <= 0;
        f <= 0;
        g <= 0;
    end else begin
        // Update x sequence register
        x_seq <= {x, x_seq[0]};
        
        // Check for sequence detection
        if (x_seq == 2'b101) begin
            seq_detected <= 1;
        end
        
        // If sequence detected, start timer and check for y
        if (seq_detected) begin
            y_timer <= y_timer + 1;
            if (y) begin
                y_seen <= 1;
            end
            if (y_timer >= 2 || y_seen) begin
                seq_detected <= 0; // Reset sequence detection flag
            end
        end else begin
            y_timer <= 0;
            y_seen <= 0;
        end
        
        // Control f and g based on state
        if (!resetn) begin
            f <= 0;
        end else if (resetn && !seq_detected && !y_seen) begin
            f <= 1;
        end else begin
            f <= 0;
        end
        
        // Set g if y seen within two cycles after sequence detection
        if (y_seen) begin
            g <= 1;
        end else if (seq_detected && y_timer >= 2) begin
            g <= 0;
        end
    end
end

endmodule