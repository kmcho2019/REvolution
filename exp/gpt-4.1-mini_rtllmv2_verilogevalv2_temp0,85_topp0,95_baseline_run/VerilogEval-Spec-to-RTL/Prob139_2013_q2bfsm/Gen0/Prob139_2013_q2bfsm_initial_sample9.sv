module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [3:0] {
        A  = 4'd0,
        B  = 4'd1,
        C0 = 4'd2,
        C1 = 4'd3,
        C2 = 4'd4,
        D0 = 4'd5,
        D1 = 4'd6,
        D2 = 4'd7,
        E  = 4'd8,
        F  = 4'd9
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            A: begin
                // Stay in A while resetn=0, else go to B after resetn=1
                if (resetn)
                    next_state = B;
            end

            B: begin
                // One cycle f=1, then start monitoring x sequence in C0
                next_state = C0;
            end

            // Detect x=1 at C0 to go to C1
            C0: begin
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0; // keep waiting for first 1
            end

            // Detect x=0 at C1 to go to C2, else if x=1 stay at C1 (to only accept strict sequence)
            C1: begin
                if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0; // if x=0 not observed properly, restart?
            end

            // Detect x=1 at C2 to go to D0 (set g=1), else if not 1 restart sequence
            C2: begin
                if (x == 1'b1)
                    next_state = D0;
                else
                    next_state = C0; // restart sequence if pattern breaks
            end

            // D0, start monitoring y for 2 cycles with g=1
            D0: begin
                if (y == 1'b1)
                    next_state = F; // y detected, g=1 permanently
                else
                    next_state = D1; // one cycle passed without y=1
            end

            // D1, second cycle monitoring y
            D1: begin
                if (y == 1'b1)
                    next_state = F; // y detected, g=1 permanently
                else
                    next_state = E; // 2 cycles passed no y=1, g=0 permanently
            end

            // D2 is unused in this design (max 2 cycles only), could be omitted

            E: begin
                // g=0 permanently until reset
                next_state = E;
            end

            F: begin
                // g=1 permanently until reset
                next_state = F;
            end

            default: next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        // defaults
        f = 1'b0;
        g = 1'b0;

        case(state)
            B: f = 1'b1; // f=1 one cycle after reset de-assertion

            D0, D1, F: g = 1'b1;
            // D2 unused - no g=1 there

            // E and others g=0
        endcase
    end

endmodule