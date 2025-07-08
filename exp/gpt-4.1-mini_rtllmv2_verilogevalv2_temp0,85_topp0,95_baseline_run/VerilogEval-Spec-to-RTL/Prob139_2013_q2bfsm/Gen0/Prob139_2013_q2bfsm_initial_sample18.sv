module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C0 = 3'd2,
        C1 = 3'd3,
        C2 = 3'd4,
        D0 = 3'd5,
        D1 = 3'd6,
        E  = 3'd7,
        F  = 3'd8
    } state_t;

    state_t state, next_state;

    // State machine sequential logic
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // FSM combinational next state and output logic
    always @(*) begin
        // Default outputs and next_state
        f = 0;
        g = 0;
        next_state = state;

        case(state)
            A: begin
                // Stay in A if resetn is low, else go to B next clock
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
                f = 0;
                g = 0;
            end

            B: begin
                // Output f=1 for one clock cycle, then go to C0
                f = 1;
                g = 0;
                next_state = C0;
            end

            // In states C0, C1, C2 monitor x sequence 1,0,1
            // Use states to track sequence progress:
            // C0: waiting for x=1
            // C1: waiting for x=0
            // C2: waiting for x=1 again
            C0: begin
                f = 0;
                g = 0;
                if (x == 1)
                    next_state = C1;
                else
                    next_state = C0; // remain until x=1
            end

            C1: begin
                f = 0;
                g = 0;
                if (x == 0)
                    next_state = C2;
                else if (x == 1)
                    next_state = C1; // if x=1 again, stay in C1 (looking for 0)
                else
                    next_state = C0; // fallback if x!=0 or 1 (but x is 1 bit)
            end

            C2: begin
                f = 0;
                g = 0;
                if (x == 1)
                    next_state = D0; // sequence 101 detected, go to D0
                else if (x == 0)
                    next_state = C0; // restart sequence if mismatch
                else
                    next_state = C0;
            end

            // D states monitor y for up to 2 cycles
            // D0: first cycle after g=1 set
            // D1: second cycle to check y
            // If y=1 in either cycle stay in E with g=1 permanently
            // else go to F with g=0 permanently

            D0: begin
                f = 0;
                g = 1;
                if (y == 1)
                    next_state = E;
                else
                    next_state = D1;
            end

            D1: begin
                f = 0;
                g = 1;
                if (y == 1)
                    next_state = E;
                else
                    next_state = F;
            end

            E: begin
                // Maintain g=1 permanently until reset
                f = 0;
                g = 1;
                next_state = E;
            end

            F: begin
                // Maintain g=0 permanently until reset
                f = 0;
                g = 0;
                next_state = F;
            end

            default: begin
                f = 0;
                g = 0;
                next_state = A;
            end
        endcase
    end
endmodule