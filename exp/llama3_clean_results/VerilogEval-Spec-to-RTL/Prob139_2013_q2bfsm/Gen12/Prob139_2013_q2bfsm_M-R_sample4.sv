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
        x_seq <= (state == STATE_TRACK_X)? (x_seq + (x? 1 : (x_seq == 1 &&!x)? -1 : 0)) : 0;
        y_count <= (state == STATE_TRACK_Y)? (y? 0 : y_count + 1) : 0;
        f <= (state == STATE_AFTER_RESET)? 1 : 0;
        g <= (state == STATE_TRACK_Y && y_count < 2)? 1 : (state == STATE_TRACK_Y && y_count >= 2)? 0 : 0;
    end
end

always @ (*) begin
    case (state)
        STATE_RESET: next_state = STATE_AFTER_RESET;
        STATE_AFTER_RESET: next_state = STATE_TRACK_X;
        STATE_TRACK_X: next_state = (x_seq == 3)? STATE_TRACK_Y : STATE_TRACK_X;
        STATE_TRACK_Y: next_state = (y_count >= 2)? STATE_TRACK_Y : STATE_TRACK_Y;
    endcase
end

endmodule