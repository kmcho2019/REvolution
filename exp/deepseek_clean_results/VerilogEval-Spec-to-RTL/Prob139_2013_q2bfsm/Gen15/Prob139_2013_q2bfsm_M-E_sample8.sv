module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam IDLE       = 2'b00;
localparam F_PULSE    = 2'b01;
localparam PATTERN    = 2'b10;
localparam MONITOR    = 2'b11;

reg [1:0] state;
reg [1:0] pattern_stage;  // Tracks progress in 1-0-1 pattern
reg timeout;               // Tracks 2-cycle window for y
reg pattern_detected;      // Flag when pattern is complete

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        pattern_stage <= 0;
        timeout <= 0;
        pattern_detected <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                // Wait one cycle after resetn deassertion
                state <= F_PULSE;
                f <= 1;
                pattern_stage <= 0;
            end
            
            F_PULSE: begin
                f <= 0;
                state <= PATTERN;
                pattern_stage <= 0;
            end
            
            PATTERN: begin
                // Edge-based pattern detection
                case (pattern_stage)
                    0: if (x) pattern_stage <= 1;  // Wait for first 1
                    1: if (!x) pattern_stage <= 2; // Then 0
                    2: if (x) begin               // Then 1
                        pattern_stage <= 0;
                        pattern_detected <= 1;
                    end
                endcase
                
                if (pattern_detected) begin
                    g <= 1;
                    state <= MONITOR;
                    timeout <= 0;
                    pattern_detected <= 0;
                end
            end
            
            MONITOR: begin
                if (y) begin
                    // Stay in this state permanently with g=1
                    g <= 1;
                end
                else if (timeout) begin
                    // After 2 cycles, set g=0 permanently
                    g <= 0;
                end
                else begin
                    timeout <= 1;  // Mark timeout after first cycle
                end
            end
        endcase
    end
end

endmodule