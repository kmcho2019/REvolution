module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum {
    RESET,
    ACTIVE,
    FINAL
} state_t;

reg [1:0] state;
reg [2:0] x_shift;    // Shift register for x pattern
reg [1:0] timer;      // 2-cycle timer for y detection
reg g_decision;       // Final decision for g

// Pattern detection
wire pattern_match = (x_shift == 3'b101);

// Timer control
wire timer_expired = (timer == 2'b00);

// State transitions and control logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 3'b0;
        timer <= 2'b0;
        g_decision <= 0;
    end else begin
        // Shift x values into register
        x_shift <= {x_shift[1:0], x};

        case (state)
            RESET: begin
                f <= 1;
                g <= 0;
                state <= ACTIVE;
            end
            
            ACTIVE: begin
                f <= 0;
                
                if (pattern_match) begin
                    // Start y detection window
                    timer <= 2'b10;
                    g <= 1;
                end
                
                if (timer > 0) begin
                    timer <= timer - 1;
                    
                    if (y) begin
                        g_decision <= 1;
                        state <= FINAL;
                    end else if (timer_expired) begin
                        g_decision <= 0;
                        state <= FINAL;
                    end
                end
            end
            
            FINAL: begin
                g <= g_decision;
            end
        endcase
    end
end

endmodule