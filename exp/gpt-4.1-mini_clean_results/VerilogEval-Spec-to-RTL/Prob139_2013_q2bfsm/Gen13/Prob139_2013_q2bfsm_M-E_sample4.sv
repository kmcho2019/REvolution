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
        ST_Y_MON    = 4'd6, // y monitoring, count cycles up to 2 with g=1
        ST_G_PERM1  = 4'd7, // permanent g=1
        ST_G_PERM0  = 4'd8  // permanent g=0
    } state_t;

    reg [3:0] state, next_state;

    // Counter for y monitoring: counts 0 to 2
    reg [1:0] y_count;
    reg y_count_enable, y_count_reset;

    // Synchronous state and counter updates
    always @(posedge clk) begin
        if (!resetn) begin
            state <= ST_A;
            y_count <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // y_count control
            if (y_count_reset)
                y_count <= 2'd0;
            else if (y_count_enable)
                y_count <= y_count + 2'd1;
            // else hold y_count

            // Outputs by state (Moore)
            case (next_state)
                ST_B:        f <= 1'b1; // f pulse for one cycle
                default:     f <= 1'b0;
            endcase

            case (next_state)
                ST_G_PULSE,
                ST_Y_MON,
                ST_G_PERM1:  g <= 1'b1;
                default:     g <= 1'b0;
            endcase
        end
    end

    // Combinational logic for next state and y_count control
    always @(*) begin
        // Default next state and counter controls
        next_state = state;
        y_count_enable = 1'b0;
        y_count_reset = 1'b0;

        case (state)
            ST_A: begin
                if (resetn)
                    next_state = ST_B; // on reset release, pulse f=1 next cycle
                else
                    next_state = ST_A;
            end

            ST_B: begin
                // One cycle f=1 done, move to pattern detection wait for x=1
                next_state = ST_P_WAIT1;
            end

            ST_P_WAIT1: begin
                if (x == 1'b1)
                    next_state = ST_P_WAIT0; // got first 1, wait for 0
                else
                    next_state = ST_P_WAIT1; // keep waiting
            end

            ST_P_WAIT0: begin
                if (x == 1'b0)
                    next_state = ST_P_WAIT1B; // got 0, wait for 1
                else if (x == 1'b1)
                    next_state = ST_P_WAIT0; // still wait for 0, x=1 doesn't advance pattern
                else
                    next_state = ST_P_WAIT1; // unknown input, restart pattern
            end

            ST_P_WAIT1B: begin
                if (x == 1'b1)
                    next_state = ST_G_PULSE; // pattern matched
                else
                    next_state = ST_P_WAIT1; // restart pattern detection
            end

            ST_G_PULSE: begin
                // one cycle g=1 pulse done, start y monitoring with g=1 and counter reset
                next_state = ST_Y_MON;
                y_count_reset = 1'b1;
            end

            ST_Y_MON: begin
                // y monitor for up to 2 cycles while g=1
                // Enable counter increment each cycle
                y_count_enable = 1'b1;

                if (y == 1'b1) begin
                    // detected y=1 within 2 cycles, permanent g=1
                    next_state = ST_G_PERM1;
                end else if (y_count == 2'd1) begin
                    // this is 2nd cycle (counts from 0), y not detected -> permanent g=0
                    next_state = ST_G_PERM0;
                end else begin
                    // continue monitoring, next cycle
                    next_state = ST_Y_MON;
                end
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
                // safe fallback to reset state
                next_state = ST_A;
            end
        endcase
    end

endmodule