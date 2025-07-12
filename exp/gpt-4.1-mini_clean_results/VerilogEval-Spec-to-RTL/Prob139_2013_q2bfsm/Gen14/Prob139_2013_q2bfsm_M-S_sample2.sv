module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active-low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [3:0] {
        A  = 4'd0,  // reset state
        B  = 4'd1,  // f=1 for one cycle after reset release
        C0 = 4'd2,  // pattern detection start, waiting for x=1
        C1 = 4'd3,  // pattern detected first '1', waiting for x=0
        C2 = 4'd4,  // pattern detected '10', waiting for x=1
        D0 = 4'd5,  // g=1, monitoring y first cycle
        D1 = 4'd6,  // g=1, monitoring y second cycle
        E  = 4'd7,  // permanent g=1
        F  = 4'd8   // permanent g=0
    } state_t;

    state_t state, next_state;

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs f and g depend only on state, assigned below
            case (next_state)
                B: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                D0, D1, E: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                F: begin
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
        next_state = state; // default hold

        case(state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After one cycle with f=1, move to pattern detection C0
                next_state = C0;
            end

            // Pattern detection states for "101" on x input each cycle
            C0: begin
                // Waiting for first '1' in pattern
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0;
            end

            C1: begin
                // After seeing first '1', waiting for '0'
                if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1; // remain if x=1 to tolerate repeated 1s
                else
                    next_state = C0; // fallback, though shouldn't happen with 1-bit x
            end

            C2: begin
                // After '10', waiting for last '1'
                if (x == 1'b1)
                    next_state = D0;
                else
                    next_state = C0; // restart pattern search on mismatch
            end

            D0: begin
                // First cycle with g=1, monitor y
                if (y == 1'b1)
                    next_state = E;
                else
                    next_state = D1;
            end

            D1: begin
                // Second cycle monitoring y
                if (y == 1'b1)
                    next_state = E;
                else
                    next_state = F;
            end

            E: begin
                // Permanent g=1 until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end

            F: begin
                // Permanent g=0 until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule