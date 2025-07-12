`timescale 1ns/1ps

module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enumerate states
typedef enum {A, SET_F, WAIT_SEQ, MONITOR_Y, G_ON, G_OFF} state_t;

state_t state, next_state;

// FSM logic
always @(*) begin
    case (state)
        A: begin
            if (~resetn) begin
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
            next_state = WAIT_SEQ;
            f = 1;
            g = 0;
        end
        WAIT_SEQ: begin
            static reg [2:0] seq_cnt = 0;
            if (x == 1 && seq_cnt == 0) begin
                seq_cnt = 1;
            end else if (x == 0 && seq_cnt == 1) begin
                seq_cnt = 2;
            end else if (x == 1 && seq_cnt == 2) begin
                seq_cnt = 3;
            end else if (seq_cnt == 3) begin
                next_state = MONITOR_Y;
                f = 0;
                g = 1;
                seq_cnt = 0;
            end else begin
                next_state = WAIT_SEQ;
                f = 0;
                g = 0;
            end
        end
        MONITOR_Y: begin
            static reg [1:0] y_cnt = 0;
            if (y == 1) begin
                next_state = G_ON;
                f = 0;
                g = 1;
                y_cnt = 0;
            end else if (y_cnt < 2) begin
                y_cnt = y_cnt + 1;
                next_state = MONITOR_Y;
                f = 0;
                g = 1;
            end else begin
                next_state = G_OFF;
                f = 0;
                g = 0;
                y_cnt = 0;
            end
        end
        G_ON: begin
            next_state = G_ON;
            f = 0;
            g = 1;
        end
        G_OFF: begin
            next_state = G_OFF;
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

// Update state on positive clock edge
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule