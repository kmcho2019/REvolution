module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);
    // State encoding
    typedef enum logic [3:0] {
        A    = 4'd0, // reset state
        F_ON = 4'd1, // f=1 for one cycle
        S1   = 4'd2, // waiting for x=1 (first bit of pattern)
        S2   = 4'd3, // got x=1, waiting for x=0
        S3   = 4'd4, // got 1,0; waiting for x=1 again
        G1   = 4'd5, // g=1 asserted, monitor y (first cycle)
        G2   = 4'd6, // g=1 asserted, monitor y (second cycle)
        G_ON = 4'd7, // g=1 permanent
        G_OFF= 4'd8  // g=0 permanent
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;
        next_state = state;

        case(state)
            A: begin
                // wait in reset state as long as resetn is low
                // When resetn goes high, next cycle f=1 one cycle
                if (resetn)
                    next_state = F_ON;
            end

            F_ON: begin
                // f=1 for one cycle then move to pattern detection
                f = 1'b1;
                next_state = S1;
            end

            S1: begin
                // Monitor x: want x=1
                if (x == 1'b1)
                    next_state = S2;
                else
                    next_state = S1; // keep waiting for x=1
            end

            S2: begin
                // After 1, expect x=0
                if (x == 1'b0)
                    next_state = S3;
                else if (x == 1'b1)
                    next_state = S2; // stay if still x=1 (pattern start again)
                else
                    next_state = S1; // fallback (shouldn't happen)
            end

            S3: begin
                // After 1,0 expect x=1
                if (x == 1'b1)
                    next_state = G1; // pattern matched, assert g next cycle
                else if (x == 1'b0)
                    next_state = S1; // restart search for pattern
                else
                    next_state = S1;
            end

            G1: begin
                g = 1'b1; // g=1 one cycle
                next_state = G2;
            end

            G2: begin
                g = 1'b1; // g=1 second cycle, start monitoring y
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = G_OFF; // y not seen within two cycles
            end

            G_ON: begin
                g = 1'b1; // g=1 permanent
                // stay here until reset
                next_state = G_ON;
            end

            G_OFF: begin
                g = 1'b0; // g=0 permanent
                // stay here until reset
                next_state = G_OFF;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule