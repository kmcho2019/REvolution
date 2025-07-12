module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

enum logic [1:0] {
    IDLE,
    SET_F,
    DETECT_SEQUENCE,
    MONITOR_Y
} state, nextState;

reg [2:0] x_sequence;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_sequence <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        case (state)
            IDLE: begin
                f <= 1; // Set f for one clock cycle after reset
                nextState <= DETECT_SEQUENCE;
            end
            SET_F: begin
                f <= 0; // Reset f after one cycle
                nextState <= DETECT_SEQUENCE;
            end
            DETECT_SEQUENCE: begin
                if (x_sequence == 3) begin
                    g <= 1;
                    nextState <= MONITOR_Y;
                end else begin
                    case (x_sequence)
                        0: if (x) x_sequence <= 1;
                        1: if (!x) x_sequence <= 2; else x_sequence <= 0;
                        2: if (x) x_sequence <= 3; else x_sequence <= 0;
                    endcase
                    nextState <= DETECT_SEQUENCE;
                end
            end
            MONITOR_Y: begin
                reg [1:0] y_timer;
                if (y) begin // Y is 1, keep g = 1 permanently
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer > 2) begin // Y did not become 1 within two cycles, set g = 0 permanently
                        g <= 0;
                    end
                end
                nextState <= MONITOR_Y;
            end
        endcase
    end
end

endmodule