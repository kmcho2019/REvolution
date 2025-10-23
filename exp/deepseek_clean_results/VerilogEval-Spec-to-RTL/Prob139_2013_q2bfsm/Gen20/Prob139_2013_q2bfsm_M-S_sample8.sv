module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [2:0] x_shift;
reg [1:0] y_counter;

localparam RESET   = 2'b00;
localparam PULSE_F = 2'b01;
localparam MONITOR = 2'b10;
localparam FINAL   = 2'b11;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_counter <= 0;
    end else begin
        // Shift register for x pattern detection
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            RESET: begin
                state <= PULSE_F;
                f <= 0;
                g <= 0;
            end
            
            PULSE_F: begin
                state <= MONITOR;
                f <= 1;
            end
            
            MONITOR: begin
                f <= 0;
                
                // Check for x pattern match
                if (x_shift == 3'b101) begin
                    g <= 1;
                    y_counter <= 0;
                end
                
                // If g is set, monitor y
                if (g) begin
                    if (y) begin
                        state <= FINAL;
                    end else if (y_counter == 2) begin
                        g <= 0;
                        state <= FINAL;
                    end else begin
                        y_counter <= y_counter + 1;
                    end
                end
            end
            
            FINAL: begin
                // Permanent state - maintain g value until reset
            end
        endcase
    end
end

endmodule