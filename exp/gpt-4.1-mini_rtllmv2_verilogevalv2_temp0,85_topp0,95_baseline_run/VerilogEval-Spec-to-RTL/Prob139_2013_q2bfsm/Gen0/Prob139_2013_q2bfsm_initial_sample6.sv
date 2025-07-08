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
    A = 4'd0,           // initial reset state
    F_ONE = 4'd1,       // f=1 for one cycle after reset deassertion
    WAIT_X1 = 4'd2,     // waiting for first x=1
    WAIT_X0 = 4'd3,     // after x=1 detected, waiting for x=0
    WAIT_X1_2 = 4'd4,   // after x=0 detected, waiting for x=1 again
    G_ON_WAIT_Y0 = 4'd5,// g=1, count 0 cycles of y monitoring
    G_ON_WAIT_Y1 = 4'd6,// g=1, count 1 cycle of y monitoring
    G_ON_PERM = 4'd7,   // g=1 permanently (y=1 detected)
    G_OFF_PERM = 4'd8   // g=0 permanently (timeout without y=1)
} state_t;

state_t state, next_state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        // Outputs depend on next state (registered outputs)
        case (next_state)
            A: begin
                f <= 0;
                g <= 0;
            end
            F_ONE: begin
                f <= 1;
                g <= 0;
            end
            WAIT_X1, WAIT_X0, WAIT_X1_2: begin
                f <= 0;
                g <= 0;
            end
            G_ON_WAIT_Y0, G_ON_WAIT_Y1, G_ON_PERM: begin
                f <= 0;
                g <= 1;
            end
            G_OFF_PERM: begin
                f <= 0;
                g <= 0;
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case(state)
        A: begin
            // Wait for resetn deassertion, then move to F_ONE
            if (resetn)
                next_state = F_ONE;
            else
                next_state = A;
        end
        F_ONE: begin
            // After asserting f=1 for one clock cycle, start monitoring x for pattern
            next_state = WAIT_X1;
        end
        WAIT_X1: begin
            // Wait for x=1 first bit of pattern
            if (x)
                next_state = WAIT_X0;
            else
                next_state = WAIT_X1;
        end
        WAIT_X0: begin
            // After detecting x=1, wait for x=0
            if (!x)
                next_state = WAIT_X1_2;
            else if (x)
                next_state = WAIT_X0; // stay until x=0
            else
                next_state = WAIT_X0;
        end
        WAIT_X1_2: begin
            // After detecting x=0, wait for x=1 again
            if (x)
                next_state = G_ON_WAIT_Y0;
            else
                next_state = WAIT_X1_2;
        end
        G_ON_WAIT_Y0: begin
            // g=1 first cycle, check y for 1 within 2 clock cycles
            if (y)
                next_state = G_ON_PERM;
            else
                next_state = G_ON_WAIT_Y1; // 1 cycle passed without y=1
        end
        G_ON_WAIT_Y1: begin
            if (y)
                next_state = G_ON_PERM;
            else
                next_state = G_OFF_PERM; // 2 cycles passed without y=1
        end
        G_ON_PERM: begin
            // g=1 permanently until reset
            next_state = G_ON_PERM;
        end
        G_OFF_PERM: begin
            // g=0 permanently until reset
            next_state = G_OFF_PERM;
        end
        default: next_state = A;
    endcase
end

endmodule