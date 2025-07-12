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
    MONITOR_Y
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
                case (seq_counter)
                    0: seq_counter <= x? seq_counter + 1 : 0;
                    1: seq_counter <= x? 0 : seq_counter + 1;
                    2: if (x) begin
                        next_state <= MONITOR_Y;
                        seq_counter <= 0;
                    end else seq_counter <= 0;
                endcase
            end
            MONITOR_Y: begin
                if (y_counter < 2) begin
                    if (y) begin
                        g <= 1;
                        next_state <= MONITOR_Y;
                    end else begin
                        y_counter <= y_counter + 1;
                        next_state <= (y_counter == 2)? DETECT_SEQ : MONITOR_Y;
                    end
                end else if (!y) begin
                    g <= 0;
                    next_state <= DETECT_SEQ;
                end
            end
        endcase
        if (state!= SET_F) f <= 0;
    end
end

endmodule