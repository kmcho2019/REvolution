module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam IDLE = 2'b00;
localparam SEQUENCE = 2'b01;
localparam FINAL = 2'b10;

reg [1:0] state;
reg [2:0] x_shift;  // Shift register for x sequence detection
reg [1:0] y_timer;   // Timer for y monitoring (0-2 cycles)

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timer <= 0;
    end else begin
        // Update shift register
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            IDLE: begin
                f <= 1;          // Pulse f high for one cycle
                g <= 0;
                state <= SEQUENCE;
            end
            
            SEQUENCE: begin
                f <= 0;          // f stays low after first cycle
                
                // Check for 1-0-1 sequence
                if (x_shift == 3'b101) begin
                    g <= 1;
                    y_timer <= 0; // Start monitoring y
                end
                
                // If g is set, monitor y for 2 cycles
                if (g) begin
                    if (y) begin
                        state <= FINAL;  // y=1 detected
                    end else if (y_timer == 2) begin
                        g <= 0;         // Timeout without y=1
                        state <= FINAL;
                    end
                    y_timer <= y_timer + 1;
                end
            end
            
            FINAL: begin
                // Permanent state - outputs remain until reset
                // No state changes needed
            end
        endcase
    end
end

endmodule