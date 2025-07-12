module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam RESET  = 2'b00;
localparam ACTIVE = 2'b01;
localparam FINAL  = 2'b10;

reg [1:0] state, next_state;
reg [2:0] x_shift;  // Shift register for x sequence
reg [1:0] timeout;  // Timeout counter for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        timeout <= 0;
    end
    else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        // Default f output (only pulses once)
        f <= 0;
        
        case (state)
            RESET: begin
                // No outputs active during reset
                f <= 0;
                g <= 0;
                x_shift <= 0;
                timeout <= 0;
            end
            
            ACTIVE: begin
                // Sequence detection
                if (x_shift == 3'b101) begin
                    g <= 1;             // Set g when sequence detected
                    timeout <= 2'b00;   // Start timeout counter
                end
                
                // y monitoring logic
                if (g && timeout < 2'b10) begin
                    if (y) begin
                        next_state <= FINAL;  // y=1 seen, keep g=1
                    end
                    timeout <= timeout + 1;
                    
                    if (timeout == 2'b01 && !y) begin
                        g <= 0;              // Timeout, set g=0
                        next_state <= FINAL;
                    end
                end
            end
            
            FINAL: begin
                // Maintain outputs until reset
                // No state changes needed
            end
        endcase
    end
end

always @(*) begin
    next_state = state;
    
    case (state)
        RESET: begin
            if (resetn) begin
                next_state = ACTIVE;
                f = 1;  // Pulse f=1 during transition
            end
        end
        
        ACTIVE: begin
            // State transitions handled in sequential block
        end
        
        FINAL: begin
            // Stay in final state until reset
        end
    endcase
end

endmodule