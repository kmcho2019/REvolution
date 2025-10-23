module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_RESET   = 2'd0;
localparam STATE_F_PULSE = 2'd1;
localparam STATE_WAIT_X  = 2'd2;
localparam STATE_WAIT_Y  = 2'd3;
localparam STATE_PERM    = 2'd4;

reg [2:0] state, next_state;
reg [1:0] x_history;    // Stores last 2 x values
reg y_detected;         // Flag for y detection
reg [1:0] timeout_cnt;  // 2-bit counter for timeout

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_RESET;
        x_history <= 2'b00;
        y_detected <= 0;
        timeout_cnt <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        
        // Update x history (shift register)
        x_history <= {x_history[0], x};
        
        // Timeout counter and y detection
        if (state == STATE_WAIT_Y) begin
            if (y) begin
                y_detected <= 1;
            end
            timeout_cnt <= timeout_cnt + 1;
        end else begin
            timeout_cnt <= 0;
        end
        
        // Output logic
        case (state)
            STATE_F_PULSE: begin
                f <= 1;
                g <= 0;
            end
            STATE_WAIT_X: begin
                f <= 0;
                g <= 0;
            end
            STATE_WAIT_Y: begin
                f <= 0;
                g <= 1;
            end
            STATE_PERM: begin
                f <= 0;
                g <= y_detected;
            end
            default: begin  // STATE_RESET
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_RESET: 
            next_state = resetn ? STATE_F_PULSE : STATE_RESET;
            
        STATE_F_PULSE: 
            next_state = STATE_WAIT_X;
            
        STATE_WAIT_X: 
            next_state = ({x_history, x} == 3'b101) ? STATE_WAIT_Y : STATE_WAIT_X;
            
        STATE_WAIT_Y: 
            if (y_detected || timeout_cnt == 2'd1)  // After 2 cycles (0→1→2)
                next_state = STATE_PERM;
            else
                next_state = STATE_WAIT_Y;
                
        STATE_PERM: 
            next_state = STATE_PERM;
            
        default: 
            next_state = STATE_RESET;
    endcase
end

endmodule