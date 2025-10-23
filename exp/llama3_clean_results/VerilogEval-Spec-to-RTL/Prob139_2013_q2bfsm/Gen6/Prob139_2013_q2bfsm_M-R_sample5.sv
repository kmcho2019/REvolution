module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [2:0] {
    RESET,
    SET_F,
    DETECT_SEQ,
    MONITOR_Y,
    PERM_G
} state, next_state;

reg [1:0] seq_counter;
reg [1:0] y_counter;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        seq_counter <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            RESET: begin
                if (resetn) next_state <= SET_F;
            end
            SET_F: begin
                f <= 1;
                next_state <= DETECT_SEQ;
            end
            DETECT_SEQ: begin
                case (seq_counter)
                    0: begin
                        if (x) seq_counter <= seq_counter + 1;
                    end
                    1: begin
                        if (!x) seq_counter <= seq_counter + 1;
                        else seq_counter <= 1;
                    end
                    2: begin
                        if (x) begin
                            next_state <= MONITOR_Y;
                            seq_counter <= 0;
                        end else seq_counter <= 0;
                    end
                endcase
            end
            MONITOR_Y: begin
                if (y_counter == 0) begin
                    y_counter <= y_counter + 1;
                    if (y) begin
                        g <= 1;
                        next_state <= PERM_G;
                    end
                end else if (y_counter == 1) begin
                    y_counter <= y_counter + 1;
                    if (y) begin
                        g <= 1;
                        next_state <= PERM_G;
                    end else begin
                        g <= 0;
                    end
                end
            end
            PERM_G: begin
                g <= 1;
            end
        endcase
        if (state == SET_F) f <= 1;
        else if (state!= SET_F) f <= 0;
    end
end

endmodule