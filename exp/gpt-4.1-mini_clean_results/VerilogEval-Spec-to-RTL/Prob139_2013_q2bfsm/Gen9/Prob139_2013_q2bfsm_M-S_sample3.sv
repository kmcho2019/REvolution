module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding (simple FSM)
    typedef enum logic [2:0] {
        A              = 3'd0, // Reset state, wait for resetn deassertion
        F_PULSE        = 3'd1, // f=1 for one cycle after resetn goes high
        MONITOR_X      = 3'd2, // Monitor pattern 1,0,1 on x
        G_ON_MONITOR_Y = 3'd3, // g=1, monitor y for up to 2 cycles
        G_ON_PERM      = 3'd4, // g=1 permanently
        G_OFF_PERM     = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // pattern_index: 0=expect first '1', 1=expect '0', 2=expect last '1'
    reg [1:0] pattern_index;

    // y_counter counts how many cycles we have been monitoring y (0 to 2)
    reg [1:0] y_counter;

    // Sequential logic: state, pattern_index, y_counter update
    always @(posedge clk) begin
        if (!resetn) begin
            state         <= A;
            pattern_index <= 2'd0;
            y_counter     <= 2'd0;
        end else begin
            state <= next_state;

            // Update pattern_index only in MONITOR_X
            if (state == MONITOR_X) begin
                case (pattern_index)
                    2'd0: pattern_index <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_index <= (x == 1'b0) ? 2'd2 :
                                          (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_index <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_index <= 2'd3; // pattern matched, hold
                    default: pattern_index <= 2'd0;
                endcase
            end else begin
                pattern_index <= 2'd0;
            end

            // Update y_counter only in G_ON_MONITOR_Y
            if (state == G_ON_MONITOR_Y) begin
                if (y_counter < 2'd2)
                    y_counter <= y_counter + 1'b1;
                else
                    y_counter <= y_counter;
            end else begin
                y_counter <= 2'd0;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // default stay

        case (state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end
            F_PULSE: begin
                // f=1 exactly one cycle then go to monitor pattern x
                next_state = MONITOR_X;
            end
            MONITOR_X: begin
                // pattern_index 3 means pattern matched: 1,0,1
                if (pattern_index == 2'd3)
                    next_state = G_ON_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end
            G_ON_MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_counter == 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end
            G_ON_PERM: next_state = G_ON_PERM;
            G_OFF_PERM: next_state = G_OFF_PERM;
            default: next_state = A;
        endcase
    end

    // Moore outputs
    assign f = (state == F_PULSE);
    assign g = (state == G_ON_MONITOR_Y) || (state == G_ON_PERM);

endmodule