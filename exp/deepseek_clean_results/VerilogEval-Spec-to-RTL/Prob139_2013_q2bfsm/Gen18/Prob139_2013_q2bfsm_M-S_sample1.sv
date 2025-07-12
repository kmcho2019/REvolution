module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg state;
reg [2:0] x_shift;
reg [1:0] y_timer;
reg pattern_matched;

localparam RESET  = 1'b0;
localparam ACTIVE = 1'b1;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timer <= 0;
        pattern_matched <= 0;
    end else begin
        case (state)
            RESET: begin
                state <= ACTIVE;
                f <= 1;  // Pulse f high
                x_shift <= 0;
            end
            
            ACTIVE: begin
                f <= 0;  // f only high for one cycle
                
                // Shift in x values
                x_shift <= {x_shift[1:0], x};
                
                // Check for 101 pattern
                if (x_shift == 3'b101) begin
                    pattern_matched <= 1;
                    g <= 1;
                    y_timer <= 0;
                end
                
                // After pattern match, monitor y
                if (pattern_matched) begin
                    if (y) begin
                        // Keep g high permanently
                        y_timer <= 2; 
                    end else if (y_timer < 2) begin
                        y_timer <= y_timer + 1;
                        if (y_timer == 1) g <= 0; // Timeout after 2 cycles
                    end
                end
            end
        endcase
    end
end

endmodule