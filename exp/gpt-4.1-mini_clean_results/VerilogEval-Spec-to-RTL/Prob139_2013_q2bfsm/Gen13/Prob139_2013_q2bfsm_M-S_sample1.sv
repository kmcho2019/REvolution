module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // reset state, f=0, g=0
        B = 3'd1, // f=1 for one cycle after resetn deasserted
        C = 3'd2, // monitor x pattern 101 using shift register
        D = 3'd3, // one cycle g=1 pulse after pattern detected
        E = 3'd4, // monitor y for up to 2 cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Shift register for last 3 samples of x in state C
    reg [2:0] x_shift;

    // Counter for monitoring y in state E (0,1, then timeout)
    reg [1:0] y_cnt;

    // Sequential logic for state, x_shift, y_cnt
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_cnt   <= 2'd0;
        end else begin
            state <= next_state;

            if (state == C)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            if (state == E)
                y_cnt <= y_cnt + 1'b1;
            else
                y_cnt <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                // Stay in A while resetn = 0, else move to B
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // one clock cycle f=1 pulse then move to C
                next_state = C;
            end
            C: begin
                // monitor x pattern 101 in last 3 samples
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // one clock cycle g=1 pulse then move to E
                next_state = E;
            end
            E: begin
                // monitor y input for up to 2 cycles while g=1
                if (y == 1'b1)
                    next_state = F; // y=1 detected: permanent g=1
                else if (y_cnt == 2'd1)
                    next_state = G; // timeout after 2 cycles: permanent g=0
                else
                    next_state = E; // continue monitoring
            end
            F: begin
                // permanent g=1 until reset
                next_state = F;
            end
            G: begin
                // permanent g=0 until reset
                next_state = G;
            end
            default: next_state = A;
        endcase
    end

    // Moore outputs based on current state
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule