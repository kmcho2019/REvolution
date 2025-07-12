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
localparam F_PULSE   = 2'b01;
localparam MONITOR_X = 2'b10;
localparam MONITOR_Y = 2'b11;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b0;
        y_counter <= 2'b0;
    end else begin
        case (state)
            RESET: state <= F_PULSE;
            
            F_PULSE: state <= MONITOR_X;
            
            MONITOR_X: begin
                x_shift <= {x_shift[1:0], x};
                if (x_shift == 3'b101) begin
                    state <= MONITOR_Y;
                    y_counter <= 2'b0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    // Stay in this state permanently
                    y_counter <= 2'b0;
                end else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                end
                // Otherwise remain in this state
            end
        endcase
    end
end

// Output logic
always @(*) begin
    f = (state == F_PULSE);
    g = (state == MONITOR_Y);
end

endmodule