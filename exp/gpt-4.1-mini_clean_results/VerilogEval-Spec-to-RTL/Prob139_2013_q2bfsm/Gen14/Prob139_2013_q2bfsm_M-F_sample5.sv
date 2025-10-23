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
        B = 3'd1, // f=1 for one cycle after resetn deassertion
        C = 3'd2, // monitor x pattern 1,0,1 using shift register
        D = 3'd3, // one cycle g=1 pulse after pattern detected
        E = 3'd4, // monitor y for up to 2 cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;       // shift register for x input samples
    reg [1:0] y_count;       // counter for y monitoring cycles

    // Sequential logic: state, x_shift, y_count updates
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift continuously except in states before pattern detection starts (A,B)
            // After the f=1 pulse (state B), start capturing x each cycle in C and subsequent states 
            // until pattern detected (when moving out of C)
            if (state == C || state == D || state == E) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                // In states where pattern detection not active, reset shift to zero
                x_shift <= 3'b000;
            end

            // y_count increments only in E to count monitoring cycles for y input
            if (state == E) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                // Stay in A while resetn=0, else go to B next clock cycle
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // One cycle f=1 pulse, then move to C to start x monitoring
                next_state = C;
            end

            C: begin
                // Monitor x for pattern 1,0,1 on last 3 bits of x_shift
                // Because x_shift is updated on every clock in C,D,E, we check here
                if (x_shift == 3'b101)
                    next_state = D; // pattern detected, pulse g=1 next cycle
                else
                    next_state = C;
            end

            D: begin
                // One clock cycle g=1 pulse after pattern detected
                // Then move to y monitoring in E
                next_state = E;
            end

            E: begin
                // Monitor y for at most two cycles with g=1
                if (y == 1'b1) begin
                    next_state = F; // y=1 detected, g=1 permanently
                end else if (y_count == 2'd1) begin
                    // Two cycles elapsed without y=1 (count starts at 0)
                    // Because y_count increments at posedge in E,
                    // when y_count==1 means two cycles have passed:
                    // cycle 0: first clock in E
                    // cycle 1: second clock in E
                    // after that move to G
                    next_state = G;
                end else begin
                    next_state = E; // keep monitoring y
                end
            end

            F: begin
                // g=1 permanently until reset
                next_state = F;
            end

            G: begin
                // g=0 permanently until reset
                next_state = G;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

    // Moore outputs based on current state
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule