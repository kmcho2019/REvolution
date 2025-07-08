module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define states
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C0 = 3'd2, // monitoring x pattern step 1: expect x=1
        C1 = 3'd3, // monitoring x pattern step 2: expect x=0
        C2 = 3'd4, // monitoring x pattern step 3: expect x=1
        D0 = 3'd5, // g=1, monitor y first clock
        D1 = 3'd6, // g=1, monitor y second clock
        E = 3'd7,  // g=1 permanent
        F = 3'd8   // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Sequential state update and synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default outputs
        f = 0;
        g = 0;
        next_state = state;

        case (state)
            A: begin
                // in reset or after reset, f=0,g=0
                f = 0;
                g = 0;
                if (resetn) begin
                    // reset deasserted -> next state B to output f=1 for one cycle
                    next_state = B;
                end
            end

            B: begin
                // output f=1 for one clock cycle
                f = 1;
                g = 0;
                next_state = C0; // start monitoring x pattern 101
            end

            // Monitor pattern x=1,0,1 in successive cycles
            C0: begin
                f = 0;
                g = 0;
                if (x == 1) begin
                    next_state = C1; // matched first bit
                end else begin
                    next_state = C0; // keep waiting for x=1
                end
            end

            C1: begin
                f = 0;
                g = 0;
                if (x == 0) begin
                    next_state = C2; // matched second bit
                end else if (x == 1) begin
                    // Restart pattern since x=1 again
                    next_state = C1;
                end else begin
                    // If x != 0 or 1 (but x is 1-bit), fallback to wait for first bit
                    next_state = C0;
                end
            end

            C2: begin
                f = 0;
                g = 0;
                if (x == 1) begin
                    next_state = D0; // matched complete pattern 101
                end else if (x == 0) begin
                    // mismatch, restart pattern search from second bit 0? No, restart from first bit
                    next_state = C0;
                end else begin
                    next_state = C0;
                end
            end

            D0: begin
                // g=1, monitor y first clock
                f = 0;
                g = 1;
                if (y == 1) begin
                    next_state = E; // maintain g=1 permanently
                end else begin
                    next_state = D1; // one more cycle to monitor y
                end
            end

            D1: begin
                // g=1, monitor y second clock
                f = 0;
                g = 1;
                if (y == 1) begin
                    next_state = E; // maintain g=1 permanently
                end else begin
                    next_state = F; // g=0 permanently
                end
            end

            E: begin
                // g=1 permanently
                f = 0;
                g = 1;
                next_state = E;
            end

            F: begin
                // g=0 permanently
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