module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        STATE_A = 3'd0, // reset asserted
        STATE_B = 3'd1, // f=1 for one cycle after reset release
        STATE_C = 3'd2, // monitor x for sequence 1,0,1
        STATE_D = 3'd3, // g=1, monitor y for up to 2 cycles
        STATE_E = 3'd4, // g=1 permanently (y=1 within 2 cycles)
        STATE_F = 3'd5  // g=0 permanently (y not 1 within 2 cycles)
    } state_t;

    state_t state, next_state;

    // To detect sequence 1,0,1 on x:
    // We can store last two x inputs and combine with current x for detection
    reg [1:0] x_shift; // x_shift[1] = x at t-2, x_shift[0] = x at t-1

    // Counter for counting y cycles in state D (up to 2 cycles)
    reg [1:0] y_count;

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (~resetn) begin
            state <= STATE_A;
            x_shift <= 2'b00;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift only in states where we monitor x (STATE_C),
            // else hold the value since no new sequence monitoring needed
            if (state == STATE_C) begin
                x_shift <= {x_shift[0], x};
            end else begin
                x_shift <= x_shift; // hold
            end

            // Update y_count in STATE_D
            if (state == STATE_D) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Defaults
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case(state)
            STATE_A: begin
                // Reset asserted
                // Stay here if resetn=0, else go to STATE_B
                if (resetn)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;

                // Outputs
                f = 1'b0;
                g = 1'b0;
            end

            STATE_B: begin
                // f=1 for one cycle
                f = 1'b1;
                g = 1'b0;
                next_state = STATE_C;
            end

            STATE_C: begin
                // f=0, g=0
                f = 1'b0;
                g = 1'b0;

                // Detect sequence 1,0,1 on x_shift + current x:
                // sequence means:
                // x_shift[1] = x at t-2 = 1
                // x_shift[0] = x at t-1 = 0
                // x = current input
                if (x_shift == 2'b10 && x == 1'b1)
                    next_state = STATE_D;
                else
                    next_state = STATE_C;
            end

            STATE_D: begin
                // g=1
                g = 1'b1;
                f = 1'b0;

                // Monitor y input for up to 2 cycles
                // y_count counts from 0, 1, 2
                // On first cycle in D: y_count=0, on next clock y_count=1, then 2
                // If y=1 at any time here (and y_count <=2), move to STATE_E permanently g=1
                // Else if y_count reaches 2 and y still 0, move to STATE_F permanently g=0

                if (y == 1'b1) begin
                    next_state = STATE_E;
                end else if (y_count == 2'd2) begin
                    next_state = STATE_F;
                end else begin
                    next_state = STATE_D;
                end
            end

            STATE_E: begin
                // g=1 permanently
                g = 1'b1;
                f = 1'b0;
                next_state = STATE_E; // hold until reset
            end

            STATE_F: begin
                // g=0 permanently
                g = 1'b0;
                f = 1'b0;
                next_state = STATE_F; // hold until reset
            end

            default: begin
                next_state = STATE_A;
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule