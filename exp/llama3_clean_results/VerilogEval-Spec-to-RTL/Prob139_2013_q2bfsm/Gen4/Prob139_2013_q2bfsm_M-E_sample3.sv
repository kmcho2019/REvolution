module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

parameter STATE_A = 4'b0000, STATE_B = 4'b0001, STATE_C = 4'b0010, STATE_D = 4'b0011, STATE_E = 4'b0100, STATE_F = 4'b0101;

reg [3:0] state, next_state;
reg [2:0] x_sequence;
reg [1:0] y_counter;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_sequence <= 3'b000;
        y_counter <= 2'b00;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= next_state;
        if (x) begin
            x_sequence <= {x_sequence[1:0], 1'b1};
        end else begin
            x_sequence <= {x_sequence[1:0], 1'b0};
        end
        if (state == STATE_D) begin
            if (y) begin
                y_counter <= 2'b00;
            end else begin
                y_counter <= y_counter + 1'b1;
            end
        end else begin
            y_counter <= 2'b00;
        end
        f <= (state == STATE_B)? 1'b1 : 1'b0;
        g <= (state == STATE_E || state == STATE_D)? 1'b1 : (state == STATE_F)? 1'b0 : g;
    end
end

always @ (*) begin
    case (state)
        STATE_A: next_state = (resetn)? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = (x_sequence == 3'b101)? STATE_D : STATE_C;
        STATE_D: next_state = (y || y_counter == 2'b11)? (y)? STATE_E : STATE_F : STATE_D;
        STATE_E: next_state = STATE_E;
        STATE_F: next_state = STATE_F;
    endcase
end

endmodule