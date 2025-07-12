module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using enum for clarity
    typedef enum logic [2:0] {
        A_RESET     = 3'd0,
        A_WAIT      = 3'd1,
        A_PULSEF    = 3'd2,
        A_SEQDETECT = 3'd3,
        A_MONITOR_Y = 3'd4,
        A_HOLD_G1   = 3'd5,
        A_HOLD_G0   = 3'd6
    } state_t;

    state_t state, next_state;

    // Shift register holds last 3 samples of x for sequence detection (sliding window)
    reg [2:0] x_shift;

    // Counter for y monitoring in MONITOR_Y state (0 to 2)
    reg [1:0] monitor_count;

    // Sequential logic: state, shift register, counter and outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A_RESET;
            x_shift <= 3'b000;
            monitor_count <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x every cycle except reset
            x_shift <= {x_shift[1:0], x};

            // Update monitor_count in MONITOR_Y, reset elsewhere
            if (state == A_MONITOR_Y)
                monitor_count <= monitor_count + 1'b1;
            else
                monitor_count <= 2'd0;

            // Output logic - Moore FSM outputs depend on current state
            case (next_state)
                A_PULSEF: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                A_MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                A_HOLD_G1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                A_HOLD_G0: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    // For states A_RESET, A_WAIT, A_SEQDETECT: f=0,g=0
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            A_RESET: begin
                if (resetn)
                    next_state = A_WAIT;
                else
                    next_state = A_RESET;
            end
            A_WAIT: begin
                // Wait one cycle after reset release, then pulse f
                next_state = A_PULSEF;
            end
            A_PULSEF: begin
                // One cycle pulse on f, then start sequence detection
                next_state = A_SEQDETECT;
            end
            A_SEQDETECT: begin
                // Detect sequence 1,0,1 in sliding window x_shift
                if (x_shift == 3'b101)
                    next_state = A_MONITOR_Y;
                else
                    next_state = A_SEQDETECT;
            end
            A_MONITOR_Y: begin
                // Monitor y for at most two cycles after entering this state
                if (y)
                    next_state = A_HOLD_G1;
                else if (monitor_count == 2'd2)
                    next_state = A_HOLD_G0;
                else
                    next_state = A_MONITOR_Y;
            end
            A_HOLD_G1: begin
                if (!resetn)
                    next_state = A_RESET;
                else
                    next_state = A_HOLD_G1;
            end
            A_HOLD_G0: begin
                if (!resetn)
                    next_state = A_RESET;
                else
                    next_state = A_HOLD_G0;
            end
            default: begin
                next_state = A_RESET;
            end
        endcase
    end

endmodule