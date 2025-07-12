module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [1:0] {
    STATE_RESET,
    STATE_AFTER_RESET,
    STATE_TRACK_X,
    STATE_TRACK_Y
} state, next_state;

reg [1:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_RESET;
        x_seq <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            STATE_AFTER_RESET: f <= 1;
            default: f <= 0;
        endcase
        
        case (state)
            STATE_TRACK_X: begin
                if (x_seq == 0 && x) x_seq <= 1;
                else if (x_seq == 1 && !x) x_seq <= 2;
                else if (x_seq == 2 && x) x_seq <= 3;
                else x_seq <= 0;
            end
            default: x_seq <= 0;
        endcase
        
        case (state)
            STATE_TRACK_Y: begin
                if (!y) y_count <= y_count + 1;
                else y_count <= 0;
            end
            default: y_count <= 0;
        endcase
        
        case (state)
            STATE_TRACK_Y: g <= (y || (y_count <= 1 && y_count != 0));
            default: g <= 0;
        endcase
    end
end

always @ (*) begin
    case (state)
        STATE_RESET: next_state = (!resetn)? STATE_RESET : STATE_AFTER_RESET;
        STATE_AFTER_RESET: next_state = STATE_TRACK_X;
        STATE_TRACK_X: next_state = (x_seq == 3)? STATE_TRACK_Y : STATE_TRACK_X;
        STATE_TRACK_Y: next_state = (y || (y_count <= 1 && y_count != 0))? STATE_TRACK_Y : (y_count >= 2)? STATE_TRACK_Y : STATE_TRACK_Y;
    endcase
end

endmodule