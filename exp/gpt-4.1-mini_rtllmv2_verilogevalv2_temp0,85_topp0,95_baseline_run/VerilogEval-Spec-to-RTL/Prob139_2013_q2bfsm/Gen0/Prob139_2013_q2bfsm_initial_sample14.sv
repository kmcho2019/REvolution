module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // For sequence detection: shift register for last 3 x inputs
    reg [2:0] x_shift;

    // Counter for monitoring y in state D
    reg [1:0] y_cnt;

    // Sequential logic for state and registers
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_cnt <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x in states C and D to detect sequence
            if (state == C) begin
                x_shift <= {x_shift[1:0], x};
            end else if (state == D) begin
                // Keep x_shift as it is or clear
                x_shift <= x_shift;
            end else begin
                x_shift <= 3'b000;
            end

            // y counter update in D
            if (state == D) begin
                y_cnt <= y_cnt + 1'b1;
            end else begin
                y_cnt <= 2'd0;
            end

            // Output f and g update on state changes
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // After one cycle f=1, go to C
                next_state = C;
            end
            C: begin
                // Detect sequence 1,0,1 in x_shift
                // x_shift is [x_shift[2], x_shift[1], x_shift[0]] with x_shift[2] oldest, x_shift[0] newest
                // We want to detect pattern: 1 (oldest),0,1 (newest)
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // g=1, monitor y for at most 2 cycles
                if (y == 1'b1)
                    next_state = E;
                else if (y_cnt == 2'd2)
                    next_state = F;
                else
                    next_state = D;
            end
            E: begin
                // g=1 permanently until reset
                next_state = E;
            end
            F: begin
                // g=0 permanently until reset
                next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule