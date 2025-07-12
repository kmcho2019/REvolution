module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// One-hot state encoding
localparam STATE_A = 4'b0001;  // Reset state
localparam STATE_B = 4'b0010;  // f=1 pulse state
localparam STATE_C = 4'b0100;  // x sequence detection
localparam STATE_D = 4'b1000;  // y monitoring and final state

reg [3:0] state, next_state;
reg [1:0] x_history;
reg y_timeout;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_history <= 2'b00;
        y_timeout <= 0;
    end
    else begin
        state <= next_state;
        
        // Default outputs
        f <= 0;
        
        case (state)
            STATE_A: begin
                // Stay in reset state
            end
            
            STATE_B: begin
                f <= 1;  // Pulse f for one cycle
            end
            
            STATE_C: begin
                // Shift in new x value
                x_history <= {x_history[0], x};
                
                // Check for 1-0-1 pattern
                if (x_history == 2'b10 && x == 1'b1) begin
                    g <= 1;
                    y_timeout <= 0;
                end
            end
            
            STATE_D: begin
                if (y) begin
                    // Keep g=1 permanently
                end
                else if (!y_timeout) begin
                    y_timeout <= 1;
                end
                else begin
                    g <= 0;  // Timeout after 2 cycles
                end
            end
        endcase
    end
end

always @(*) begin
    next_state = state;
    
    case (state)
        STATE_A: begin
            if (resetn) next_state = STATE_B;
        end
        
        STATE_B: begin
            next_state = STATE_C;
        end
        
        STATE_C: begin
            // Check for complete 1-0-1 sequence
            if (x_history == 2'b10 && x == 1'b1)
                next_state = STATE_D;
        end
        
        STATE_D: begin
            // Stay in final state until reset
        end
    endcase
end

endmodule