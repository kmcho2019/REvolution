module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    enum {A, SET_F, MONITOR_X, SET_G, MONITOR_Y1, MONITOR_Y2, STABLE_G, STABLE_G_ZERO} state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (~resetn) next_state = A;
                else next_state = SET_F;
            end
            SET_F: begin
                next_state = MONITOR_X;
            end
            MONITOR_X: begin
                if (x) next_state = MONITOR_X1;
                else next_state = MONITOR_X;
            end
            MONITOR_X1: begin
                if (~x) next_state = MONITOR_X2;
                else next_state = MONITOR_X1;
            end
            MONITOR_X2: begin
                if (x) next_state = SET_G;
                else next_state = MONITOR_X;
            end
            SET_G: begin
                next_state = MONITOR_Y1;
            end
            MONITOR_Y1: begin
                if (y) next_state = STABLE_G;
                else next_state = MONITOR_Y2;
            end
            MONITOR_Y2: begin
                if (y) next_state = STABLE_G;
                else next_state = STABLE_G_ZERO;
            end
            STABLE_G: begin
                next_state = STABLE_G;
            end
            STABLE_G_ZERO: begin
                next_state = STABLE_G_ZERO;
            end
        endcase
    end

    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
        end
        else begin
            state <= next_state;
            case (state)
                SET_F: f <= 1;
                default: f <= 0;
            endcase
            case (state)
                SET_G, MONITOR_Y1, MONITOR_Y2, STABLE_G: g <= 1;
                default: g <= 0;
            endcase
        end
    end

    initial begin
        state = A;
        f = 0;
        g = 0;
    end

endmodule