module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [1:0] {
    INIT,
    WAIT,
    DONE
} state_t;

state_t state;
reg [2:0] x_pattern;
reg [1:0] timeout_counter;
reg g_latched;

// Parallel pattern detection
wire pattern_match = (x_pattern == 3'b101);

always @(posedge clk) begin
    if (!resetn) begin
        state <= INIT;
        f <= 1'b0;
        g <= 1'b0;
        g_latched <= 1'b0;
        x_pattern <= 3'b0;
        timeout_counter <= 2'b0;
    end
    else begin
        // Shift x input for pattern detection
        x_pattern <= {x_pattern[1:0], x};
        
        case (state)
            INIT: begin
                f <= 1'b1;
                g <= 1'b0;
                state <= WAIT;
            end
            
            WAIT: begin
                f <= 1'b0;
                
                if (pattern_match && !g_latched) begin
                    g <= 1'b1;
                    timeout_counter <= 2'b10; // Initialize 2-cycle counter
                end
                
                // Monitor y during timeout period
                if (timeout_counter > 0) begin
                    timeout_counter <= timeout_counter - 1;
                    
                    if (y) begin
                        g_latched <= 1'b1; // Permanent g=1
                        state <= DONE;
                    end
                    else if (timeout_counter == 1) begin
                        g <= 1'b0;
                        g_latched <= 1'b1; // Permanent g=0
                        state <= DONE;
                    end
                end
            end
            
            DONE: begin
                // Maintain latched outputs until reset
                g <= g_latched;
            end
        endcase
    end
end

endmodule