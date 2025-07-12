module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    enum {A, SET_F, WAIT_X1, WAIT_X0, WAIT_X1_AGAIN, MONITOR_Y1, MONITOR_Y2} state, next_state;

    // Initialize state and outputs
    initial begin
        state = A;
        f = 0;
        g = 0;
    end

    // Sequential logic
    always @(posedge clk) begin
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
                SET_F: begin
                    f <= 1;
                    g <= 0;
                end
                WAIT_X1: begin
                    f <= 0;
                    g <= 0;
                end
                WAIT_X0: begin
                    f <= 0;
                    g <= 0;
                end
                WAIT_X1_AGAIN: begin
                    f <= 0;
                    g <= 0;
                end
                MONITOR_Y1: begin
                    f <= 0;
                    g <= 1;
                end
                MONITOR_Y2: begin
                    f <= 0;
                    g <= 1;
                end
            endcase
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        case (state)
            A: begin
                if (resetn) next_state = SET_F;
                else next_state = A;
            end
            SET_F: next_state = WAIT_X1;
            WAIT_X1: begin
                if (x) next_state = WAIT_X0;
                else next_state = WAIT_X1;
            end
            WAIT_X0: begin
                if (!x) next_state = WAIT_X1_AGAIN;
                else next_state = WAIT_X1;
            end
            WAIT_X1_AGAIN: begin
                if (x) next_state = MONITOR_Y1;
                else next_state = WAIT_X1_AGAIN;
            end
            MONITOR_Y1: begin
                if (y) next_state = A; // Maintain g=1, go back to A to wait for next sequence
                else next_state = MONITOR_Y2;
            end
            MONITOR_Y2: begin
                if (y) next_state = A; // Maintain g=1, go back to A to wait for next sequence
                else next_state = A; // Set g=0 permanently, go back to A
            end
        endcase
    end

endmodule