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
reg [1:0] y_counter; // Counter for y timeout
reg f_pulse;         // Flag for f output pulse
reg seq_detected;    // Flag for 1-0-1 sequence
reg y_monitoring;    // Flag for y monitoring phase

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 3'b000;
        y_counter <= 2'b00;
        f_pulse <= 0;
        seq_detected <= 0;
        y_monitoring <= 0;
    end
    else begin
        state <= next_state;
        
        // Shift in new x value
        x_shift <= {x_shift[1:0], x};
        
        // Default outputs
        f <= 0;
        
        case (state)
            RESET: begin
                // Prepare for f pulse
                f_pulse <= 1;
            end
            
            ACTIVE: begin
                if (f_pulse) begin
                    f <= 1;
                    f_pulse <= 0;
                end
                
                // Check for 1-0-1 sequence
                if (x_shift == 3'b101) begin
                    seq_detected <= 1;
                    g <= 1;
                    y_monitoring <= 1;
                    y_counter <= 2'b00;
                end
                
                // Y monitoring logic
                if (y_monitoring) begin
                    if (y) begin
                        y_monitoring <= 0;  // Keep g=1 permanently
                    end
                    else if (y_counter == 2'b01) begin
                        g <= 0;             // Timeout after 2 cycles
                        y_monitoring <= 0;
                    end
                    else begin
                        y_counter <= y_counter + 1;
                    end
                end
            end
            
            FINAL: begin
                // Maintain outputs until reset
            end
        endcase
    end
end

always @(*) begin
    next_state = state;
    
    case (state)
        RESET: begin
            if (resetn) next_state = ACTIVE;
        end
        
        ACTIVE: begin
            if (seq_detected && !y_monitoring)
                next_state = FINAL;
        end
        
        FINAL: begin
            // Stay in final state until reset
        end
    endcase
end

endmodule