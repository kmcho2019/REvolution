module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum {IDLE, SET_F, DETECT_SEQ, MONITOR_Y, SET_G_1, SET_G_0} state, next_state;

reg [1:0] x_seq; // Shift register to hold last two values of x
reg [1:0] y_timer; // Timer to count cycles after sequence detection

always @(*) begin
    case(state)
        IDLE: begin
            if (!resetn) next_state = IDLE;
            else next_state = SET_F;
        end
        SET_F: begin
            next_state = DETECT_SEQ;
        end
        DETECT_SEQ: begin
            if (x_seq == 2'b101) next_state = MONITOR_Y;
            else next_state = DETECT_SEQ;
        end
        MONITOR_Y: begin
            if (y) next_state = SET_G_1;
            else if (y_timer == 2) next_state = SET_G_0;
            else next_state = MONITOR_Y;
        end
        SET_G_1: next_state = SET_G_1;
        SET_G_0: next_state = SET_G_0;
        default: next_state = IDLE;
    endcase
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_seq <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        
        // Update x sequence register
        x_seq <= {x, x_seq[0]};
        
        case(state)
            SET_F: f <= 1;
            default: f <= 0;
        endcase
        
        case(state)
            MONITOR_Y: begin
                y_timer <= y_timer + 1;
            end
            default: y_timer <= 0;
        endcase
        
        case(state)
            SET_G_1: g <= 1;
            SET_G_0: g <= 0;
            default: g <= g;
        endcase
    end
end

endmodule