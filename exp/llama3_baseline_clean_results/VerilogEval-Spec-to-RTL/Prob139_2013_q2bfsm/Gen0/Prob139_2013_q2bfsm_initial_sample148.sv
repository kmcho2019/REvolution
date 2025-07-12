module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;
parameter E = 4'b0100;

reg [3:0] state, next_state;
reg [2:0] x_seq, next_x_seq;
reg [1:0] y_timer, next_y_timer;

// Reset state
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_timer <= 0;
    end else begin
        state <= next_state;
        f <= (state == B)? 1 : 0;
        g <= (state == D)? 1 : (state == E)? 0 : g;
        x_seq <= next_x_seq;
        y_timer <= next_y_timer;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    next_x_seq = x_seq;
    next_y_timer = y_timer;

    case(state)
        A: begin
            if (resetn) begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
            next_x_seq = 0;
        end
        C: begin
            next_x_seq = {x_seq[1:0], x};
            if (x_seq == 5) begin
                next_state = D;
                next_y_timer = 0;
            end
        end
        D: begin
            next_y_timer = y_timer + 1;
            if (y) begin
                next_state = D;
                next_y_timer = 0;
            end else if (y_timer == 2) begin
                next_state = E;
            end
        end
        E: begin
            next_state = E;
        end
        default: next_state = A;
    endcase
end

endmodule