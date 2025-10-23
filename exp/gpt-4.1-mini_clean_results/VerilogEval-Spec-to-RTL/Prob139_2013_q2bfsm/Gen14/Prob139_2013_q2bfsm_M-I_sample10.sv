module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // Define states
    typedef enum reg [3:0] {
        ST_A        = 4'd0, // Reset state (state A)
        ST_B        = 4'd1, // f=1 pulse (1 cycle)
        ST_P_WAIT1  = 4'd2, // Wait for x=1 (pattern detect start)
        ST_P_WAIT0  = 4'd3, // Got 1, wait for 0
        ST_P_WAIT1B = 4'd4, // Got 1,0 wait for 1
        ST_G_PULSE  = 4'd5, // g=1 pulse (1 cycle)
        ST_Y_MON    = 4'd6, // y monitoring with 2-cycle counter
        ST_G_PERM1  = 4'd7, // permanent g=1
        ST_G_PERM0  = 4'd8  // permanent g=0
    } state_t;

    reg [3:0] state, next_state;

    // Counter for y monitoring: counts 0,1,2 cycles
    reg [1:0] y_count;

    // Sequential logic: state and counter update, outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state <= ST_A;
            y_count <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // y_count logic
            // Reset y_count when entering ST_Y_MON
            if (next_state == ST_Y_MON && state != ST_Y_MON)
                y_count <= 2'd0;
            else if (state == ST_Y_MON)
                y_count <= y_count + 2'd1;
            else
                y_count <= 2'd0; // hold or reset outside y monitoring

            // Outputs assigned by current state (Moore)
            case (state)
                ST_B:        f <= 1'b1;
                default:     f <= 1'b0;
            endcase

            case (state)
                ST_G_PULSE,
                ST_Y_MON,
                ST_G_PERM1:  g <= 1'b1;
                default:     g <= 1'b0;
            endcase
        end
    end

    // Combinational logic: next state
    always @(*) begin
        next_state = state; // default hold

        case (state)
            ST_A: begin
                if (resetn)
                    next_state = ST_B;
                else
                    next_state = ST_A;
            end

            ST_B: begin
                // After one cycle pulse of f=1, go to pattern detection
                next_state = ST_P_WAIT1;
            end

            ST_P_WAIT1: begin
                if (x == 1'b1)
                    next_state = ST_P_WAIT0;
                else
                    next_state = ST_P_WAIT1;
            end

            ST_P_WAIT0: begin
                if (x == 1'b0)
                    next_state = ST_P_WAIT1B;
                else if (x == 1'b1)
                    next_state = ST_P_WAIT0; // remain waiting for 0, input 1 does not progress pattern
                else
                    next_state = ST_P_WAIT1; // safety fallback
            end

            ST_P_WAIT1B: begin
                if (x == 1'b1)
                    next_state = ST_G_PULSE;
                else
                    next_state = ST_P_WAIT1; // restart pattern detection
            end

            ST_G_PULSE: begin
                // After one cycle pulse g=1, start y monitoring
                next_state = ST_Y_MON;
            end

            ST_Y_MON: begin
                // Monitor y for at most 2 cycles (y_count counts 0,1)
                if (y == 1'b1)
                    next_state = ST_G_PERM1; // permanent g=1
                else if (y_count == 2'd1)
                    next_state = ST_G_PERM0; // after 2 cycles y not seen
                else
                    next_state = ST_Y_MON; // keep monitoring
            end

            ST_G_PERM1: begin
                // permanent g=1 until reset
                next_state = ST_G_PERM1;
            end

            ST_G_PERM0: begin
                // permanent g=0 until reset
                next_state = ST_G_PERM0;
            end

            default: begin
                next_state = ST_A;
            end
        endcase
    end

endmodule