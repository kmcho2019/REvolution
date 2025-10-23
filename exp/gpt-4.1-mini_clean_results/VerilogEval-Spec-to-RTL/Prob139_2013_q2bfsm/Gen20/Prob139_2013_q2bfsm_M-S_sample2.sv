module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // Reset state
        B = 3'd1, // f=1 one cycle after reset released
        C = 3'd2, // Monitor x pattern 101 step-by-step
        D = 3'd3, // g=1 one cycle pulse after pattern detected
        E = 3'd4, // Monitor y for up to 2 cycles with g=1
        F = 3'd5, // permanent g=1
        G = 3'd6  // permanent g=0
    } state_t;

    state_t state, next_state;

    // Pattern progress:
    // 0 = no progress
    // 1 = matched x=1 at current cycle (expect x=0 next)
    // 2 = matched x=1 then x=0 (expect x=1 next)
    // 3 = matched full 101 pattern
    reg [1:0] pat_progress;

    // y timer counter for max 2 cycles in state E
    reg [1:0] y_timer;

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state        <= A;
            pat_progress <= 2'd0;
            y_timer      <= 2'd0;
            f            <= 1'b0;
            g            <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // Stay in A while reset asserted, outputs 0
                    pat_progress <= 2'd0;
                    y_timer      <= 2'd0;
                    f <= 1'b0;
                    g <= 1'b0;
                end

                B: begin
                    // One cycle f=1 pulse
                    f <= 1'b1;
                    g <= 1'b0;
                    pat_progress <= 2'd0;
                    y_timer <= 2'd0;
                end

                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_timer <= 2'd0;

                    // Update pattern progress tracking the 101 sequence stepwise
                    case (pat_progress)
                        2'd0: pat_progress <= (x == 1'b1) ? 2'd1 : 2'd0;
                        2'd1: pat_progress <= (x == 1'b0) ? 2'd2 : ((x == 1'b1) ? 2'd1 : 2'd0);
                        2'd2: pat_progress <= (x == 1'b1) ? 2'd3 : ((x == 1'b1) ? 2'd1 : 2'd0);
                        2'd3: pat_progress <= 2'd3; // already matched pattern, will move on next state
                        default: pat_progress <= 2'd0;
                    endcase
                end

                D: begin
                    // One cycle g=1 pulse after pattern detected
                    f <= 1'b0;
                    g <= 1'b1;
                    pat_progress <= 2'd0;
                    y_timer <= 2'd0;
                end

                E: begin
                    f <= 1'b0;
                    g <= 1'b1;

                    // Count number of cycles in E (max 2)
                    y_timer <= y_timer + 2'd1;
                    pat_progress <= 2'd0;
                end

                F: begin
                    // permanent g=1
                    f <= 1'b0;
                    g <= 1'b1;
                    pat_progress <= 2'd0;
                    y_timer <= y_timer;
                end

                G: begin
                    // permanent g=0
                    f <= 1'b0;
                    g <= 1'b0;
                    pat_progress <= 2'd0;
                    y_timer <= y_timer;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    pat_progress <= 2'd0;
                    y_timer <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // default stay

        case (state)
            A: begin
                // Wait for reset to be de-asserted
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After one cycle f=1 pulse go to pattern monitoring
                next_state = C;
            end

            C: begin
                // Transition to D when full pattern matched (pat_progress=3)
                if (pat_progress == 2'd3)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // After one cycle g=1 pulse move to monitor y
                next_state = E;
            end

            E: begin
                if (y)
                    next_state = F;          // y detected in time, permanent g=1
                else if (y_timer == 2'd1)
                    next_state = G;          // y not detected within two cycles, permanent g=0
                else
                    next_state = E;          // keep monitoring y
            end

            F: next_state = F;                // hold permanent g=1
            G: next_state = G;                // hold permanent g=0

            default: next_state = A;
        endcase
    end

endmodule