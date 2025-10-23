module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding as enum
    typedef enum reg [2:0] {
        A = 3'd0, // reset state, f=0, g=0
        B = 3'd1, // f=1 for one cycle
        C = 3'd2, // monitor x pattern (shift register)
        D = 3'd3, // g=1 for one cycle pulse after pattern detection
        E = 3'd4, // monitor y up to 2 cycles with g=1
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;  // shift register for x inputs in state C
    reg [1:0] y_count;  // count cycles monitoring y in state E

    always @(posedge clk) begin
        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'b00;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    // stay here until resetn=1, no outputs asserted
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                B: begin
                    // f=1 pulse for one cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                C: begin
                    // f=0, g=0, shift in x input
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= {x_shift[1:0], x};
                    y_count <= 2'b00;
                end

                D: begin
                    // g=1 pulse for one cycle, f=0
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                E: begin
                    // maintain g=1, monitor y for up to 2 cycles
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= 3'b000;

                    // y_count increments every cycle in E if y not detected
                    if (y == 1'b1) begin
                        y_count <= 2'b00; // reset counter when y=1 detected
                    end else begin
                        y_count <= y_count + 1'b1;
                    end
                end

                F: begin
                    // g=1 permanent until reset
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                G: begin
                    // g=0 permanent until reset
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
            endcase
        end
    end

    // Next state logic purely combinational
    always @(*) begin
        next_state = state; // default hold

        case(state)
            A: begin
                // Wait for reset release, move to B on next clk after resetn=1
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After one cycle f=1 pulse, go to monitor x pattern
                next_state = C;
            end

            C: begin
                // Shift register updated in sequential block, detect pattern 101
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // One cycle g=1 pulse, then go to y monitoring state
                next_state = E;
            end

            E: begin
                // Monitor y input for up to two cycles
                if (y == 1'b1)
                    next_state = F; // y=1 detected, g=1 permanent
                else if (y_count == 2'd1)
                    // two cycles passed without y=1
                    next_state = G; // g=0 permanent
                else
                    next_state = E; // keep waiting
            end

            F: begin
                // Hold g=1 permanent
                next_state = F;
            end

            G: begin
                // Hold g=0 permanent
                next_state = G;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule