module TopModule(
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM States
    typedef enum reg [2:0] {
        A = 3'd0, // reset state, f=0,g=0
        B = 3'd1, // f=1 one cycle after reset release
        C0 = 3'd2, // waiting for x=1 (pattern step 0)
        C1 = 3'd3, // waiting for x=0 (pattern step 1)
        C2 = 3'd4, // waiting for x=1 (pattern step 2)
        D = 3'd5, // g=1 one cycle after pattern detected
        E = 3'd6, // g=1 monitoring y for up to 2 cycles
        F = 3'd7  // permanent g=1 (after y=1 detected)
        // State G (g=0 permanently) is the default reset back to A after failure
    } state_t;

    state_t state, next_state;

    reg [1:0] y_count; // counts cycles in E

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state   <= next_state;

            // Update y_count only in E
            if (state == E) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end

            // Outputs driven by state (Moore outputs)
            case (next_state)
                A: begin f <= 1'b0; g <= 1'b0; end
                B: begin f <= 1'b1; g <= 1'b0; end
                C0,C1,C2: begin f <= 1'b0; g <= 1'b0; end
                D: begin f <= 1'b0; g <= 1'b1; end
                E: begin f <= 1'b0; g <= 1'b1; end
                F: begin f <= 1'b0; g <= 1'b1; end
                default: begin f <= 1'b0; g <= 1'b0; end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                // Stay here while resetn=0 (actually handled by sync reset)
                // Once resetn=1, move to B
                next_state = B;
            end

            B: begin
                // After one cycle f=1, move to C0 to start pattern detection
                next_state = C0;
            end

            // Pattern detection states
            C0: begin
                // Expect x=1 to advance to C1, else remain in C0
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0;
            end

            C1: begin
                // Expect x=0 to advance to C2, else restart from C0
                if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1; // stay in C1 if x==1 (allow repeats)
                else
                    next_state = C0; // fallback
            end

            C2: begin
                // Expect x=1 to advance to D (pattern complete), else restart C0
                if (x == 1'b1)
                    next_state = D;
                else
                    next_state = C0;
            end

            D: begin
                // Output g=1 one cycle, then move to E to monitor y
                next_state = E;
            end

            E: begin
                // g=1 while monitoring y for up to two cycles
                if (y == 1'b1) begin
                    next_state = F; // permanent g=1
                end else if (y_count == 2'd1) begin
                    // Two cycles elapsed with no y=1 -> go to A (g=0 permanently by reset)
                    next_state = A;
                end else begin
                    next_state = E; // keep monitoring
                end
            end

            F: begin
                // Permanent g=1 until reset
                next_state = F;
            end

            default: next_state = A;
        endcase
    end

endmodule