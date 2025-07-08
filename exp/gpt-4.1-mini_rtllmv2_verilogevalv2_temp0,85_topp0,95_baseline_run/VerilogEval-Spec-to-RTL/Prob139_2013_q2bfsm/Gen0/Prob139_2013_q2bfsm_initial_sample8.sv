module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // Reset state
        B = 3'd1, // f=1 for one cycle
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1, monitor y for up to 2 cycles
        E = 3'd4, // g=1 permanently
        F = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // For pattern detection in state C
    // We need to detect x sequence: 1,0,1 in consecutive cycles.
    // We'll store previous two x samples and current x to compare.
    reg x_d1, x_d2;

    // For counting y observation cycles in state D (max 2 cycles)
    reg [1:0] y_count;

    // Sequential logic: state, outputs, and sampling x
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_d1 <= 0;
            x_d2 <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;

            // Sample x history for pattern detection in state C
            // Update only in state C or D (since we stop monitoring x after)
            if (state == C) begin
                x_d2 <= x_d1;
                x_d1 <= x;
            end

            // Outputs depend on state
            case (next_state)
                A: begin
                    f <= 0;
                    g <= 0;
                end
                B: begin
                    f <= 1; // f=1 for one clock cycle
                    g <= 0;
                end
                C: begin
                    f <= 0;
                    g <= 0;
                end
                D: begin
                    f <= 0;
                    g <= 1;
                end
                E: begin
                    f <= 0;
                    g <= 1;
                end
                F: begin
                    f <= 0;
                    g <= 0;
                end
                default: begin
                    f <= 0;
                    g <= 0;
                end
            endcase

            // y_count counter updated in state D
            if (state == D) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                // Stay in A while resetn=0, else go to B after resetn=1
                if (resetn)
                    next_state = B;
            end
            B: begin
                // After one cycle with f=1, go to C to monitor x
                next_state = C;
            end
            C: begin
                // Check if x pattern 1,0,1 detected in three consecutive clocks
                // We have x_d2 (2 cycles ago), x_d1 (1 cycle ago), and current x
                if ({x_d2, x_d1, x} == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // While g=1, monitor y for at most two cycles
                if (y == 1) begin
                    next_state = E; // maintain g=1 permanently
                end else if (y_count == 2) begin
                    next_state = F; // g=0 permanently if y not detected
                end else begin
                    next_state = D; // continue monitoring
                end
            end
            E: begin
                // g=1 permanently until reset
                next_state = E;
            end
            F: begin
                // g=0 permanently until reset
                next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule