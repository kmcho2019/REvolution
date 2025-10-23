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
                else next_state <= RESET;
            end
            SET_F: begin
                f <= 1;
                next_state <= DETECT_SEQ;
            end
            DETECT_SEQ: begin
                if (seq_counter == 0 && x) seq_counter <= seq_counter + 1;
                else if (seq_counter == 1 &&!x) seq_counter <= seq_counter + 1;
                else if (seq_counter == 2 && x) next_state <= MONITOR_Y;
                else seq_counter <= 0;
            end
            MONITOR_Y: begin
                if (y_counter == 0) begin
                    if (y) begin
                        g <= 1;
                        next_state <= PERM_G;
                    end else y_counter <= y_counter + 1;
                end else if (y_counter == 1) begin
                    if (y) begin
                        g <= 1;
                        next_state <= PERM_G;
                    end else begin
                        g <= 0;
                        next_state <= DETECT_SEQ;
                    end
                end
            end
            PERM_G: begin
                g <= 1;
            end
        endcase
        if (state!= SET_F) f <= 0;
    end
end

endmodule