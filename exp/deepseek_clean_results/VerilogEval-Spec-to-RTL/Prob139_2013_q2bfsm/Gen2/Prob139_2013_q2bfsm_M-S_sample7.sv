module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A      = 3'b000;
localparam STATE_MONITOR = 3'b001;
localparam STATE_CHECK_Y = 3'b010;
localparam STATE_G_HIGH = 3'b011;
localparam STATE_G_LOW  = 3'b100;

reg [2:0] state, next_state;
reg [2:0] x_pattern;  // Shift register for 1-0-1 pattern
reg [1:0] y_counter;  // Counter for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_pattern <= 0;
        y_counter <= 0;
    end else begin
        state <= next_state;
        
        // Shift register for x pattern detection
        x_pattern <= {x_pattern[1:0], x};
        
        // Y monitoring counter
        if (state == STATE_CHECK_Y) begin
            y_counter <= y_counter + 1;
        end else begin
            y_counter <= 0;
        end
        
        // Output logic
        f <= (state == STATE_A);
        case (state)
            STATE_CHECK_Y: g <= 1;
            STATE_G_HIGH: g <= 1;
            STATE_G_LOW:  g <= 0;
            default:      g <= 0;
        endcase
    end
end

always @(*) begin
    case (state)
        STATE_A: next_state = STATE_MONITOR;
        STATE_MONITOR: 
            next_state = (x_pattern == 3'b101) ? STATE_CHECK_Y : STATE_MONITOR;
        STATE_CHECK_Y:
            if (y) 
                next_state = STATE_G_HIGH;
            else if (y_counter == 2'd1) 
                next_state = STATE_G_LOW;
            else 
                next_state = STATE_CHECK_Y;
        default: next_state = state;  // Stay in terminal states
    endcase
end

endmodule