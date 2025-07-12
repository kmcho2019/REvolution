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

localparam RESET     = 2'b00;
localparam PULSE_F   = 2'b01;
localparam MONITOR_X = 2'b10;
localparam MONITOR_Y = 2'b11;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            RESET: begin
                state <= PULSE_F;
                f <= 0;
                g <= 0;
            end
            
            PULSE_F: begin
                f <= 1;
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                f <= 0;
                x_shift <= {x_shift[1:0], x};
                
                if (x_shift == 3'b101) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_counter <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    // Stay in this state with g=1 permanently
                    y_counter <= 2;
                end else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 1) begin
                        g <= 0;
                        state <= MONITOR_X;  // Return to monitor x for new patterns
                    end
                end
            end
        endcase
    end
end

endmodule