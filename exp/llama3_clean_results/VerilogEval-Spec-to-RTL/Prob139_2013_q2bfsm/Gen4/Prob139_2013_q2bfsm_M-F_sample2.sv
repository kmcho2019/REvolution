module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

parameter STATE_A = 0, STATE_B = 1, STATE_C = 2, STATE_D = 3, STATE_E = 4, STATE_F = 5;

reg [2:0] state, next_state;
reg [2:0] x_seq;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_seq <= 3'b000;
        y_count <= 2'b00;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= next_state;
        if (x) begin
            x_seq <= {x_seq[1:0], 1'b1};
        end else begin
            x_seq <= {x_seq[1:0], 1'b0};
        end
        if (state == STATE_D) begin
            if (y) begin
                y_count <= 2'b00;
            end else begin
                y_count <= y_count + 1'b1;
            end
        end else begin
            y_count <= 2'b00;
        end
        f <= (state == STATE_B)? 1'b1 : 1'b0;
        if (state == STATE_E) begin
            g <= 1'b1;
        end else if (state == STATE_F) begin
            g <= 1'b0;
        end else begin
            g <= (state == STATE_D && y_count < 2'b10)? 1'b0 : g;
        end
    end
end

always @ (*) begin
    case (state)
        STATE_A: next_state = (resetn)? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = ({x_seq[2], x_seq[1], x_seq[0]} == 3'b101)? STATE_D : STATE_C;
        STATE_D: next_state = (y || y_count == 2'b11)? (y)? STATE_E : STATE_F : STATE_D;
        STATE_E: next_state = STATE_E;
        STATE_F: next_state = STATE_F;
    endcase
end

endmodule