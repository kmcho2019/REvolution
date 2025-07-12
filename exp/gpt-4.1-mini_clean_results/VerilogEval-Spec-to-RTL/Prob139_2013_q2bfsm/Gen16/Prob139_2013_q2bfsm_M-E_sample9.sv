module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM states encoding (one-hot or binary)
    typedef enum reg [3:0] {
        A   = 4'd0,  // Reset state, f=0,g=0
        B   = 4'd1,  // f=1 for one cycle after reset
        C1  = 4'd2,  // Wait for x==1 (first bit of pattern)
        C2  = 4'd3,  // Wait for x==0 (second bit of pattern)
        C3  = 4'd4,  // Wait for x==1 (third bit of pattern)
        D   = 4'd5,  // g=1 one cycle pulse after pattern matched
        E0  = 4'd6,  // Monitor y cycle 1 with g=1
        E1  = 4'd7,  // Monitor y cycle 2 with g=1
        F   = 4'd8,  // g=1 permanent
        G   = 4'd9   // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Sequential state and output update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            // Moore outputs depend on next_state, update outputs synchronously
            case (next_state)
                A: begin f <= 1'b0; g <= 1'b0; end
                B: begin f <= 1'b1; g <= 1'b0; end
                C1: begin f <= 1'b0; g <= 1'b0; end
                C2: begin f <= 1'b0; g <= 1'b0; end
                C3: begin f <= 1'b0; g <= 1'b0; end
                D: begin f <= 1'b0; g <= 1'b1; end
                E0: begin f <= 1'b0; g <= 1'b1; end
                E1: begin f <= 1'b0; g <= 1'b1; end
                F:  begin f <= 1'b0; g <= 1'b1; end
                G:  begin f <= 1'b0; g <= 1'b0; end
                default: begin f <= 1'b0; g <= 1'b0; end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;  // default hold

        case(state)
            A: begin
                // stay in A while reset asserted; on release move to B
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After one cycle f=1, start pattern detection: wait for x==1
                next_state = C1;
            end

            C1: begin
                // Wait for x==1 to start pattern
                if (x == 1'b1)
                    next_state = C2;
                else
                    next_state = C1;
            end

            C2: begin
                // Wait for x==0 (second bit)
                if (x == 1'b0)
                    next_state = C3;
                else if (x == 1'b1)
                    // Restart pattern detection if x==1 here (consider overlapping)
                    next_state = C2; // stay here, waiting for 0 after 1
                else
                    next_state = C2; // default stay
            end

            C3: begin
                // Wait for x==1 (third bit)
                if (x == 1'b1)
                    next_state = D;  // pattern matched
                else if (x == 1'b0)
                    // pattern failed, restart detection for first bit
                    next_state = C1;
                else
                    next_state = C3; // default stay
            end

            D: begin
                // g=1 pulse for one clock cycle, then start monitoring y up to two cycles
                next_state = E0;
            end

            E0: begin
                if (y == 1'b1)
                    next_state = F; // y detected, permanent g=1
                else
                    next_state = E1; // one cycle wait done, one left
            end

            E1: begin
                if (y == 1'b1)
                    next_state = F; // y detected, permanent g=1
                else
                    next_state = G; // two cycles elapsed, y not detected, g=0 permanent
            end

            F: begin
                // g=1 permanent, stay here until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end

            G: begin
                // g=0 permanent, stay here until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = G;
            end

            default: next_state = A;
        endcase
    end

endmodule