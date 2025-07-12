module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET      = 3'b000;
localparam PULSE_F    = 3'b001;
localparam MONITOR_X  = 3'b010;
localparam CHECK_Y    = 3'b011;
localparam LOCKED     = 3'b100;

reg [2:0] state;
reg [2:0] x_shift;
reg [1:0] y_timer;
reg g_value;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b000;
        y_timer <= 2'b00;
        g_value <= 1'b0;
    end else begin
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        case (state)
            RESET: 
                state <= PULSE_F;
                
            PULSE_F: 
                state <= MONITOR_X;
                
            MONITOR_X: begin
                if (x_shift == 3'b101) begin
                    state <= CHECK_Y;
                    y_timer <= 2'b00;
                end
            end
                
            CHECK_Y: begin
                if (y) begin
                    g_value <= 1'b1;
                    state <= LOCKED;
                end else if (y_timer == 2'b01) begin
                    g_value <= 1'b0;
                    state <= LOCKED;
                end
                y_timer <= y_timer + 1;
            end
            
            LOCKED: 
                // Stay in locked state until reset
                state <= LOCKED;
        endcase
    end
end

// Output logic
assign f = (state == PULSE_F);
assign g = (state == LOCKED) ? g_value : 
           ((state == CHECK_Y) && (y_timer == 2'b00 || (y_timer == 2'b01 && g_value)));

endmodule