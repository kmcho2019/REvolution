module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
parameter A = 2'b00, SET_F = 2'b01, CHECK_X = 2'b10, SET_G = 2'b11, CHECK_Y = 2'b100, G_PERM_ON = 2'b101, G_PERM_OFF = 2'b110;
reg [2:0] state, next_state;

// Internal signals
reg [1:0] x_sequence;
reg [1:0] y_timer;

always @(*) begin
    case(state)
        A: begin
            if(!resetn) begin
                next_state = A;
                f = 0;
                g = 0;
            end else begin
                next_state = SET_F;
                f = 0;
                g = 0;
            end
        end
        SET_F: begin
            next_state = CHECK_X;
            f = 1;
            g = 0;
        end
        CHECK_X: begin
            if(x_sequence == 2'b10 && x == 1'b1) begin
                next_state = SET_G;
                f = 0;
                g = 0;
                x_sequence = 2'b00;
            end else if(x_sequence == 2'b00 && x == 1'b1) begin
                next_state = CHECK_X;
                f = 0;
                g = 0;
                x_sequence = 2'b01;
            end else if(x_sequence == 2'b01 && x == 1'b0) begin
                next_state = CHECK_X;
                f = 0;
                g = 0;
                x_sequence = 2'b10;
            end else if(x_sequence == 2'b01 && x == 1'b1) begin
                next_state = CHECK_X;
                f = 0;
                g = 0;
                x_sequence = 2'b01;
            end else if(x_sequence == 2'b00 && x == 1'b0) begin
                next_state = CHECK_X;
                f = 0;
                g = 0;
                x_sequence = 2'b00;
            end
        end
        SET_G: begin
            next_state = CHECK_Y;
            f = 0;
            g = 1;
            y_timer = 2'b00;
        end
        CHECK_Y: begin
            if(y == 1'b1) begin
                next_state = G_PERM_ON;
                f = 0;
                g = 1;
            end else if(y_timer == 2'b10) begin
                next_state = G_PERM_OFF;
                f = 0;
                g = 0;
            end else begin
                next_state = CHECK_Y;
                f = 0;
                g = 1;
                y_timer = y_timer + 1'b1;
            end
        end
        G_PERM_ON: begin
            next_state = G_PERM_ON;
            f = 0;
            g = 1;
        end
        G_PERM_OFF: begin
            next_state = G_PERM_OFF;
            f = 0;
            g = 0;
        end
        default: begin
            next_state = A;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
        state <= A;
        x_sequence <= 2'b00;
        y_timer <= 2'b00;
    end else begin
        state <= next_state;
        if(state == CHECK_X) begin
            if(x_sequence == 2'b10 && x == 1'b1) begin
                x_sequence <= 2'b00;
            end else if(x_sequence == 2'b00 && x == 1'b1) begin
                x_sequence <= 2'b01;
            end else if(x_sequence == 2'b01 && x == 1'b0) begin
                x_sequence <= 2'b10;
            end else if(x_sequence == 2'b01 && x == 1'b1) begin
                x_sequence <= 2'b01;
            end else if(x_sequence == 2'b00 && x == 1'b0) begin
                x_sequence <= 2'b00;
            end
        end
    end
end

endmodule