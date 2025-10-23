module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    enum logic [2:0] {
        IDLE,
        F_SET,
        X_SEQ_DETECT_1,
        X_SEQ_DETECT_0,
        X_SEQ_DETECT_2,
        G_CTRL
    } state, next_state;

    reg [1:0] y_count;
    reg y_count_next;

    // Sequential logic
    always @ (posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            f <= 0;
            g <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;
            f <= (next_state == F_SET) ? 1 : 0;
            g <= (next_state == G_CTRL && (y || (y_count >= 2))) ? 1 : (next_state == G_CTRL && y_count == 2) ? 0 : g;
            y_count <= y_count_next;
        end
    end

    // Combinational logic
    always @ (*) begin
        next_state = state;
        y_count_next = y_count;
        case (state)
            IDLE: begin
                next_state = F_SET;
            end
            F_SET: begin
                next_state = X_SEQ_DETECT_1;
            end
            X_SEQ_DETECT_1: begin
                if (x) begin
                    next_state = X_SEQ_DETECT_1;
                end else begin
                    next_state = X_SEQ_DETECT_0;
                end
            end
            X_SEQ_DETECT_0: begin
                if (x) begin
                    next_state = X_SEQ_DETECT_2;
                end else begin
                    next_state = X_SEQ_DETECT_1;
                end
            end
            X_SEQ_DETECT_2: begin
                next_state = G_CTRL;
            end
            G_CTRL: begin
                if (y) begin
                    y_count_next = 0;
                end else if (y_count < 2) begin
                    y_count_next = y_count + 1;
                end
            end
        endcase
    end
endmodule