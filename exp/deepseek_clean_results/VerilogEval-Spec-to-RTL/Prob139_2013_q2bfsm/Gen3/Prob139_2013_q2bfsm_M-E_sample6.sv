module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam RESET   = 1'b0;
localparam ACTIVE  = 1'b1;

reg state;
reg [2:0] x_window;  // Sliding window for 101 detection
reg [1:0] y_timer;   // Timer for y monitoring
reg seq_detected;    // Sequence detected flag
reg y_timeout;       // Timeout flag

// Main state machine
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_window <= 3'b0;
        y_timer <= 2'b0;
        seq_detected <= 1'b0;
        y_timeout <= 1'b0;
    end else begin
        // Update sliding window
        x_window <= {x_window[1:0], x};
        
        // State transition
        case (state)
            RESET: begin
                state <= ACTIVE;
            end
            
            ACTIVE: begin
                // Detect 101 sequence
                if (x_window == 3'b101) begin
                    seq_detected <= 1'b1;
                end
                
                // Timer logic when sequence detected
                if (seq_detected) begin
                    if (y) begin
                        y_timeout <= 1'b0;  // y=1 detected
                    end else if (y_timer < 2'b10) begin
                        y_timer <= y_timer + 1'b1;
                    end else begin
                        y_timeout <= 1'b1;   // Timeout reached
                    end
                end
            end
        endcase
    end
end

// Output generation
always @(*) begin
    f = 1'b0;
    g = 1'b0;
    
    if (state == ACTIVE) begin
        // Generate f pulse one cycle after reset
        if (x_window == 3'b0 && !seq_detected) begin
            f = 1'b1;
        end
        
        // Generate g based on conditions
        if (seq_detected) begin
            if (y || !y_timeout) begin
                g = 1'b1;
            end else begin
                g = 1'b0;
            end
        end
    end
end

endmodule