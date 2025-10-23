module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using localparams for synthesis compatibility
    localparam [2:0]
        A = 3'd0, // reset state, f=0, g=0
        B = 3'd1, // f=1 for one cycle after resetn deasserted
        C = 3'd2, // monitor x pattern 101 using shift register
        D = 3'd3, // one cycle g=1 pulse after pattern detected
        E = 3'd4, // monitor y for up to 2 cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6; // g=0 permanently

    reg [2:0] state, next_state;

    // Shift register for last 3 samples of x in state C
    reg [2:0] x_shift;

    // Counter for monitoring y in state E (0,1,2)
    reg [1:0] y_cnt;

    // Sequential logic: state, x_shift, y_cnt updates
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_cnt   <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs (Moore style) updated after state update
            case (next_state)
                B: f <= 1'b1;
                default: f <= 1'b0;
            endcase

            case (next_state)
                D, E, F: g <= 1'b1;
                default: g <= 1'b0;
            endcase

            // Shift register update and pattern detection
            if (next_state == C) begin
                // Shift in current x value
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000; // clear shift register outside C
            end

            // y counter management
            if (state != E && next_state == E) begin
                // On entry to E, reset counter to 0
                y_cnt <= 2'd0;
            end else if (next_state == E) begin
                // Increment counter while in E
                y_cnt <= y_cnt + 1'b1;
            end else begin
                y_cnt <= 2'd0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                // Stay in A while resetn=0; move to B when resetn=1
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // One cycle f=1, then go to C
                next_state = C;
            end
            C: begin
                // Wait for x_shift to detect 3-bit pattern 101
                // Pattern is only valid if last three bits equal 3'b101
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // One cycle g=1 pulse, then move to E
                next_state = E;
            end
            E: begin
                // Monitor y for at most 2 cycles (count 0 and 1)
                // If y=1 detected, go to permanent g=1 (F)
                // Else if timeout after 2 cycles (y_cnt==2), go to permanent g=0 (G)
                if (y == 1'b1)
                    next_state = F;
                else if (y_cnt == 2'd2)
                    next_state = G;
                else
                    next_state = E;
            end
            F: begin
                // Permanent g=1 until reset
                next_state = F;
            end
            G: begin
                // Permanent g=0 until reset
                next_state = G;
            end
            default: next_state = A;
        endcase
    end

endmodule