module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active-low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (binary)
    localparam [2:0]
        A = 3'd0,  // Reset state
        B = 3'd1,  // f=1 for one cycle
        C = 3'd2,  // Pattern detection on x
        D = 3'd3,  // g=1, monitor y with timer
        E = 3'd4,  // g=1 permanent
        F = 3'd5;  // g=0 permanent

    reg [2:0] state, next_state;

    // Shift register to hold last 3 x inputs, valid only in C
    reg [2:0] x_shift;

    // 2-bit timer for y monitoring in D
    reg [1:0] y_timer;

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b0;
            y_timer <= 2'b0;
        end else begin
            state <= next_state;

            case(next_state)
                A: begin
                    // Reset all registers in reset state
                    x_shift <= 3'b0;
                    y_timer <= 2'b0;
                end
                B: begin
                    // Prepare for pattern detection next cycle
                    x_shift <= 3'b0;
                    y_timer <= 2'b0;
                end
                C: begin
                    // Shift in x every clock for pattern detection
                    x_shift <= {x_shift[1:0], x};
                    y_timer <= 2'b0;
                end
                D: begin
                    // Keep x_shift steady, increment y_timer (max 2)
                    x_shift <= x_shift;
                    if (y_timer < 2)
                        y_timer <= y_timer + 1'b1;
                end
                E: begin
                    // Permanent g=1 state, hold regs steady
                    x_shift <= x_shift;
                    y_timer <= y_timer;
                end
                F: begin
                    // Permanent g=0 state, hold regs steady
                    x_shift <= x_shift;
                    y_timer <= y_timer;
                end
                default: begin
                    x_shift <= 3'b0;
                    y_timer <= 2'b0;
                end
            endcase
        end
    end

    // Next-state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case(state)
            A: begin
                // Stay here while reset asserted
                if (resetn)
                    next_state = B; // On reset release go to B
                else
                    next_state = A;
            end
            B: begin
                // After asserting f=1 for one cycle, go to pattern detection
                next_state = C;
            end
            C: begin
                // Detect pattern "101" in x_shift
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // Monitor y for up to 2 cycles
                if (y == 1'b1)
                    next_state = E;  // y=1 detected => g=1 permanent
                else if (y_timer >= 2)
                    next_state = F;  // timeout => g=0 permanent
                else
                    next_state = D;
            end
            E: begin
                // Permanent g=1 state until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end
            F: begin
                // Permanent g=0 state until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end
            default: next_state = A;
        endcase
    end

    // Output logic (Moore machine): driven by current state
    always @(*) begin
        case(state)
            A: begin
                f = 1'b0;
                g = 1'b0;
            end
            B: begin
                f = 1'b1;  // assert f=1 for one cycle
                g = 1'b0;
            end
            C: begin
                f = 1'b0;
                g = 1'b0;
            end
            D: begin
                f = 1'b0;
                g = 1'b1;
            end
            E: begin
                f = 1'b0;
                g = 1'b1;
            end
            F: begin
                f = 1'b0;
                g = 1'b0;
            end
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule