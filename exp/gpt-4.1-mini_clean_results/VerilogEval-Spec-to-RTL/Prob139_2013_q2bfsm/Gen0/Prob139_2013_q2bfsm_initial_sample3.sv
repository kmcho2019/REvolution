module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A        = 3'd0,
        F_set    = 3'd1,
        X1       = 3'd2,
        X2       = 3'd3,
        X3       = 3'd4,
        G_monitor= 3'd5,
        G_hold   = 3'd6,
        G_clear  = 3'd7
    } state_t;

    state_t state, next_state;

    // Counter for monitoring y in G_monitor state
    reg [1:0] y_counter;

    // State transition combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                if (resetn) next_state = F_set;
                else        next_state = A;
            end

            F_set: next_state = X1;

            X1: next_state = (x == 1'b1) ? X2 : X1;

            X2: next_state = (x == 1'b0) ? X3 : X1;

            X3: next_state = (x == 1'b1) ? G_monitor : X1;

            G_monitor: begin
                if (y == 1'b1)       next_state = G_hold;
                else if (y_counter==2'd2) next_state = G_clear;
                else                 next_state = G_monitor;
            end

            G_hold:  next_state = G_hold;
            G_clear: next_state = G_clear;

            default: next_state = A;
        endcase
    end

    // Sequential logic: state update and outputs
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            y_counter <= 2'd0;
        end else begin
            state <= next_state;

            // Default outputs
            f <= 1'b0;

            case(next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_counter <= 2'd0;
                end

                F_set: begin
                    f <= 1'b1; // output f=1 for one cycle
                    g <= 1'b0;
                    y_counter <= 2'd0;
                end

                X1: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_counter <= 2'd0;
                end

                X2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_counter <= 2'd0;
                end

                X3: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_counter <= 2'd0;
                end

                G_monitor: begin
                    f <= 1'b0;
                    g <= 1'b1;

                    // increment y_counter if y=0, else hold at current value (not needed here)
                    y_counter <= y_counter + 2'd1;
                end

                G_hold: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_clear: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_counter <= 2'd0;
                end
            endcase
        end
    end

endmodule