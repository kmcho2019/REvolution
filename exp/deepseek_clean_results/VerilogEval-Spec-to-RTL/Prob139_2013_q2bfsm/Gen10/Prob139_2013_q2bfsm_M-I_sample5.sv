module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definitions
localparam RESET     = 3'b000;
localparam IDLE      = 3'b001;
localparam PULSE_F   = 3'b010;
localparam MONITOR_X = 3'b011;
localparam CHECK_Y   = 3'b100;
localparam FINAL     = 3'b101;

reg [2:0] state;
reg [1:0] x_counter;  // Counts x samples
reg [1:0] x_sequence; // Stores last 2 x values
reg y_timeout;        // 1-bit counter for y timeout

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        x_sequence <= 0;
        y_timeout <= 0;
    end
    else begin
        case (state)
            RESET: begin
                state <= IDLE;
                f <= 0;
                g <= 0;
            end
            
            IDLE: begin
                state <= PULSE_F;
            end
            
            PULSE_F: begin
                f <= 1;
                state <= MONITOR_X;
                x_counter <= 0;
            end
            
            MONITOR_X: begin
                f <= 0;
                // Store x history
                x_sequence <= {x_sequence[0], x};
                
                if (x_counter < 2) begin
                    x_counter <= x_counter + 1;
                end
                else begin
                    // Check for 1-0-1 sequence (current x is last bit)
                    if ({x_sequence, x} == 3'b101) begin
                        g <= 1;
                        state <= CHECK_Y;
                        y_timeout <= 0;
                    end
                    x_counter <= 0;
                end
            end
            
            CHECK_Y: begin
                if (y) begin
                    state <= FINAL;
                end
                else if (y_timeout) begin
                    g <= 0;
                    state <= FINAL;
                end
                else begin
                    y_timeout <= 1;
                end
            end
            
            FINAL: begin
                // Maintain g output until reset
                // No state changes needed
            end
        endcase
    end
end

endmodule