module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

enum logic [2:0] {A, F_SET, WAIT_SEQ, SEQ_1, SEQ_2, WAIT_Y, G_SET_PERM, G_CLEAR_PERM} state, next_state;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            A: begin
                f <= 0;
                g <= 0;
            end
            F_SET: begin
                f <= 1;
                g <= 0;
            end
            WAIT_SEQ: begin
                f <= 0;
                g <= 0;
            end
            SEQ_1: begin
                f <= 0;
                g <= 0;
            end
            SEQ_2: begin
                f <= 0;
                g <= 0;
            end
            WAIT_Y: begin
                f <= 0;
                g <= 1;
            end
            G_SET_PERM: begin
                f <= 0;
                g <= 1;
            end
            G_CLEAR_PERM: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

always_comb begin
    case (state)
        A: begin
            if (resetn) begin
                next_state = F_SET;
            end else begin
                next_state = A;
            end
        end
        F_SET: begin
            next_state = WAIT_SEQ;
        end
        WAIT_SEQ: begin
            if (x) begin
                next_state = SEQ_1;
            end else begin
                next_state = WAIT_SEQ;
            end
        end
        SEQ_1: begin
            if (!x) begin
                next_state = SEQ_2;
            end else begin
                next_state = SEQ_1;
            end
        end
        SEQ_2: begin
            if (x) begin
                next_state = WAIT_Y;
            end else begin
                next_state = WAIT_SEQ;
            end
        end
        WAIT_Y: begin
            if (y || (next_state == G_SET_PERM)) begin
                next_state = G_SET_PERM;
            end else if (next_state == G_CLEAR_PERM) begin
                next_state = G_CLEAR_PERM;
            end else begin
                next_state = (state == WAIT_Y) ? (y ? G_SET_PERM : (next_state == G_SET_PERM ? G_SET_PERM : WAIT_Y)) : WAIT_Y;
                if (~y) begin
                    next_state = G_SET_PERM;
                end else begin
                    next_state = G_CLEAR_PERM;
                end
            end
            if (~y && next_state != G_SET_PERM) begin
                next_state = G_CLEAR_PERM;
            end
        end
        G_SET_PERM: begin
            next_state = G_SET_PERM;
        end
        G_CLEAR_PERM: begin
            next_state = G_CLEAR_PERM;
        end
    endcase
end

endmodule