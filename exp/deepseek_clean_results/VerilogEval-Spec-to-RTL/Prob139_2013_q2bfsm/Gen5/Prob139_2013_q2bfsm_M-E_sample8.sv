module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// One-hot state encoding
localparam S_RESET  = 4'b0001;
localparam S_PULSE  = 4'b0010;
localparam S_WAIT   = 4'b0100;
localparam S_MONITOR = 4'b1000;

reg [3:0] state;
reg [2:0] x_shift;    // 3-bit shift register for x sequence
reg [1:0] y_timeout;  // 2-bit timeout counter

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= S_RESET;
        f <= 0;
        g <= 0;
        x_shift <= 3'b000;
        y_timeout <= 2'b00;
    end else begin
        // Shift in new x value
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            S_RESET: begin
                f <= 0;
                g <= 0;
                state <= S_PULSE;
            end
            
            S_PULSE: begin
                f <= 1;
                state <= S_WAIT;
            end
            
            S_WAIT: begin
                f <= 0;
                // Check for 1,0,1 sequence (MSB first)
                if (x_shift == 3'b101) begin
                    g <= 1;
                    state <= S_MONITOR;
                    y_timeout <= 2'b00;
                end
            end
            
            S_MONITOR: begin
                if (y) begin
                    // Stay in this state with g=1 permanently
                    state <= S_MONITOR;
                end else if (y_timeout == 2'b10) begin
                    // Timeout after 2 cycles (counts 0,1,2)
                    g <= 0;
                    state <= S_MONITOR; // Stay here permanently
                end else begin
                    y_timeout <= y_timeout + 1;
                end
            end
            
            default: state <= S_RESET;
        endcase
    end
end

endmodule