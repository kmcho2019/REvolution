module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [1:0] {
    STATE_A,
    STATE_B,
    STATE_SEQ,
    STATE_WAIT_Y
} state, next_state;

reg [1:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_seq <= 2'b00;
        y_count <= 2'b00;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= next_state;
        if (state == STATE_SEQ) begin
            x_seq <= {x_seq[0], x};
        end else begin
            x_seq <= 2'b00;
        end
        if (state == STATE_WAIT_Y) begin
            y_count <= y_count + 1'b1;
        end else begin
            y_count <= 2'b00;
        end
        if (state == STATE_B) begin
            f <= 1'b1;
        end else begin
            f <= 1'b0;
        end
        if ((state == STATE_WAIT_Y) && (y || y_count == 2'b10)) begin
            g <= (y)? 1'b1 : 1'b0;
        end else if (state == STATE_SEQ && x_seq == 2'b101) begin
            g <= 1'b1;
        end else if (state != STATE_WAIT_Y && state != STATE_SEQ) begin
            g <= 1'b0;
        end
    end
end

always @ (*) begin
    case (state)
        STATE_A: next_state = (resetn)? STATE_B : STATE_A;
        STATE_B: next_state = STATE_SEQ;
        STATE_SEQ: next_state = (x_seq == 2'b101)? STATE_WAIT_Y : STATE_SEQ;
        STATE_WAIT_Y: next_state = (y || y_count == 2'b10)? ((y)? STATE_WAIT_Y : STATE_A) : STATE_WAIT_Y;
    endcase
end

endmodule