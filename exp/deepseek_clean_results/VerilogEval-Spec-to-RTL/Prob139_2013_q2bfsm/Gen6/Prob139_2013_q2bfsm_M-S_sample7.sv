module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Simplified state encoding
localparam STATE_A = 2'd0;  // Reset/initial state
localparam STATE_B = 2'd1;  // Sequence detection
localparam STATE_C = 2'd2;  // y monitoring
localparam STATE_D = 2'd3;  // Final state

reg [1:0] state;
reg [2:0] x_shift;  // Shift register for 1-0-1 detection
reg [1:0] y_counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_counter <= 0;
    end
    else begin
        // Default outputs
        f <= 0;
        
        case (state)
            STATE_A: begin
                f <= 1;  // Generate f pulse
                state <= STATE_B;
            end
            
            STATE_B: begin
                // Shift in new x value
                x_shift <= {x_shift[1:0], x};
                
                // Check for 1-0-1 pattern
                if (x_shift == 3'b101) begin
                    g <= 1;
                    state <= STATE_C;
                    y_counter <= 0;
                end
            end
            
            STATE_C: begin
                if (y) begin
                    state <= STATE_D;  // y=1 detected
                end
                else if (y_counter == 1) begin
                    g <= 0;           // Timeout after 2 cycles
                    state <= STATE_D;
                end
                y_counter <= y_counter + 1;
            end
            
            STATE_D: begin
                // Permanent state - maintain g value
            end
        endcase
    end
end

endmodule