module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam RESET      = 2'b00;
localparam PULSE_F    = 2'b01;
localparam OPERATIONAL = 2'b10;

reg [1:0] state;
reg [2:0] x_shift;  // Shift register for x sequence detection
reg [1:0] y_timeout; // Counter for y monitoring timeout
reg sequence_detected;
reg y_monitoring;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 3'b000;
        y_timeout <= 0;
        sequence_detected <= 0;
        y_monitoring <= 0;
    end
    else begin
        // Shift x input into the shift register
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            RESET: begin
                f <= 0;
                g <= 0;
                if (resetn) state <= PULSE_F;
            end
            
            PULSE_F: begin
                f <= 1;
                state <= OPERATIONAL;
            end
            
            OPERATIONAL: begin
                f <= 0;  // f is only high for one cycle
                
                // Detect 1-0-1 sequence
                if (x_shift == 3'b101 && !sequence_detected) begin
                    g <= 1;
                    sequence_detected <= 1;
                    y_monitoring <= 1;
                    y_timeout <= 0;
                end
                
                // Handle y monitoring
                if (y_monitoring) begin
                    if (y) begin
                        // Lock g to 1 permanently
                        y_monitoring <= 0;
                    end
                    else if (y_timeout == 2'd1) begin
                        // Timeout reached, lock g to 0
                        g <= 0;
                        y_monitoring <= 0;
                    end
                    else begin
                        y_timeout <= y_timeout + 1;
                    end
                end
            end
        endcase
    end
end

endmodule