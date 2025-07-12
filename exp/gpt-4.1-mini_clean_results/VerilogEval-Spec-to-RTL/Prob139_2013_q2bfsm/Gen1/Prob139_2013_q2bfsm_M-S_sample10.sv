module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    parameter A        = 3'd0;
    parameter F_SET    = 3'd1;
    parameter X1       = 3'd2;
    parameter X2       = 3'd3;
    parameter X3       = 3'd4;
    parameter G_MONITOR= 3'd5;
    parameter G_HOLD   = 3'd6;
    parameter G_CLEAR  = 3'd7;

    reg [2:0] state, next_state;
    reg [1:0] y_count;  // Counts clock cycles in G_MONITOR state

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = F_SET;
                else
                    next_state = A;
            end

            F_SET: next_state = X1;

            X1: next_state = (x == 1'b1) ? X2 : X1;

            X2: next_state = (x == 1'b0) ? X3 : X1;

            X3: next_state = (x == 1'b1) ? G_MONITOR : X1;

            G_MONITOR: begin
                if (y == 1'b1)
                    next_state = G_HOLD;
                else if (y_count == 2)
                    next_state = G_CLEAR;
                else
                    next_state = G_MONITOR;
            end

            G_HOLD:  next_state = G_HOLD;
            G_CLEAR: next_state = G_CLEAR;

            default: next_state = A;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end

                F_SET: begin
                    f <= 1'b1;    // f=1 for one clock cycle
                    g <= 1'b0;
                    y_count <= 2'd0;
                end

                X1, X2, X3: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end

                G_MONITOR: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    y_count <= y_count + 1'b1;
                end

                G_HOLD: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    // y_count not relevant here
                end

                G_CLEAR: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    // y_count not relevant here
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

endmodule