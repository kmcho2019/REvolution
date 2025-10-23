module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D,
    STATE_E,
    STATE_F
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
        x_seq <= {x_seq[0], x};
        if (state == STATE_D) begin
            y_count <= y_count + 1'b1;
        end else begin
            y_count <= 2'b00;
        end
        if (state == STATE_B) begin
            f <= 1'b1;
        end else begin
            f <= 1'b0;
        end
        if ((state == STATE_E) || (state == STATE_D && y_count < 2'b10)) begin
            g <= 1'b1;
        end else if (state == STATE_D && y_count >= 2'b10) begin
            g <= 1'b0;
        end
    end
end

always @ (*) begin
    case (state)
        STATE_A: next_state = (resetn)? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = (x_seq == 2'b11)? STATE_D : STATE_C;
        STATE_D: next_state = (y || y_count == 2'b10)? (y)? STATE_E : STATE_F : STATE_D;
        STATE_E: next_state = STATE_E;
        STATE_F: next_state = STATE_F;
    endcase
end

endmodule