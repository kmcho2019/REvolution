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
        A = 3'd0,       // Reset state
        F_ONE = 3'd1,   // f=1 for one cycle
        WAIT_X1 = 3'd2, // Waiting for first x=1
        WAIT_X0 = 3'd3, // Waiting for x=0 after x=1
        WAIT_X2 = 3'd4, // Waiting for x=1 after 1,0 pattern
        G_ON_0 = 3'd5,  // g=1, wait y first clock
        G_ON_1 = 3'd6,  // g=1, wait y second clock
        G_ON_PERM = 3'd7, // g=1 permanently
        G_OFF_PERM = 3'd8 // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Sequential state transition and output logic
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs
            f <= 1'b0; 
            // g default is to keep current value, but handle g output in next_state logic

            case(state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                F_ONE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                WAIT_X1, WAIT_X0, WAIT_X2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                G_ON_0, G_ON_1, G_ON_PERM: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                G_OFF_PERM: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                if (resetn) next_state = F_ONE;
                else next_state = A;
            end
            F_ONE: begin
                // After one cycle with f=1, start waiting for x pattern
                next_state = WAIT_X1;
            end
            WAIT_X1: begin
                // Waiting for x=1 to start pattern
                if (x == 1'b1)
                    next_state = WAIT_X0;
                else
                    next_state = WAIT_X1;
            end
            WAIT_X0: begin
                // Waiting for x=0 after previous x=1
                if (x == 1'b0)
                    next_state = WAIT_X2;
                else if (x == 1'b1)
                    next_state = WAIT_X0; // stay here if x=1 (still waiting for 0)
                else
                    next_state = WAIT_X0;
            end
            WAIT_X2: begin
                // Waiting for x=1 to complete 1,0,1 sequence
                if (x == 1'b1)
                    next_state = G_ON_0;
                else if (x == 1'b0)
                    next_state = WAIT_X1; // restart search for pattern
                else
                    next_state = WAIT_X2;
            end
            G_ON_0: begin
                // g=1 first cycle after pattern detected, monitor y first cycle
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_ON_1;
            end
            G_ON_1: begin
                // g=1 second cycle monitoring y
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else
                    next_state = G_OFF_PERM;
            end
            G_ON_PERM: begin
                // g=1 permanent until reset
                next_state = G_ON_PERM;
            end
            G_OFF_PERM: begin
                // g=0 permanent until reset
                next_state = G_OFF_PERM;
            end
            default: next_state = A;
        endcase
    end

endmodule