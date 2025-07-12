module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // Reset state, f=0,g=0
        B = 3'd1, // One cycle f=1 pulse
        C = 3'd2, // Pattern detection (1-0-1 on x)
        D = 3'd3, // g=1 and monitor y for up to 2 cycles
        E = 3'd4, // g=1 permanently
        F = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Pattern progress: 0=no match, 1=matched '1', 2=matched '1-0', 3=matched '1-0-1'
    logic [1:0] pat_prog;

    // Counter for y monitoring cycles in D state (max 2)
    logic [1:0] y_count;

    // Sequential logic: state, pattern progress, y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            pat_prog <= 2'd0;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update pattern progress only in C state
            if (state == C) begin
                case (pat_prog)
                    2'd0: pat_prog <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pat_prog <= (x == 1'b0) ? 2'd2 : (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pat_prog <= (x == 1'b1) ? 2'd3 : (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd3: pat_prog <= (x == 1'b1) ? 2'd1 : 2'd0; // after match, restart detection
                    default: pat_prog <= 2'd0;
                endcase
            end else begin
                pat_prog <= 2'd0; // reset outside pattern detection
            end

            // Update y_count only in D state
            if (state == D) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: if (resetn) next_state = B;

            B: next_state = C; // One cycle f=1 pulse done, go detect pattern

            C: begin
                if (pat_prog == 2'd3)
                    next_state = D; // Pattern matched
                else
                    next_state = C; // keep detecting
            end

            D: begin
                if (y == 1'b1)
                    next_state = E; // y found, g=1 permanent
                else if (y_count == 2'd2)
                    next_state = F; // y not found within 2 cycles
                else
                    next_state = D; // keep monitoring y
            end

            E: next_state = E; // hold until reset
            F: next_state = F; // hold until reset

            default: next_state = A;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case (state)
            B: f = 1'b1;
            D, E: g = 1'b1;
            default: begin end
        endcase
    end

endmodule