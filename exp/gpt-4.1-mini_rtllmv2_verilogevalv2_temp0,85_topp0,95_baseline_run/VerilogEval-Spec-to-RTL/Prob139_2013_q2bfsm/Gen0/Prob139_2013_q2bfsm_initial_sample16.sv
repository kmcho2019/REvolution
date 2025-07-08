module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 one cycle
        C = 3'd2, // wait for x pattern 1,0,1
        D = 3'd3, // g=1, monitor y for up to 2 cycles
        E = 3'd4  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // For pattern detector on x: track last 3 samples of x
    reg [2:0] x_shift;

    // Counter for number of clocks in state D monitoring y
    reg [1:0] d_counter;

    // Next state and outputs logic combinational
    always @(*) begin
        // Default next state and outputs
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case(state)
            A: begin
                // In reset state, f=0,g=0
                // Wait for resetn deasserted to move to B
                if (resetn == 1'b1)
                    next_state = B;
            end

            B: begin
                // f=1 for one cycle, then move to C
                f = 1'b1;
                next_state = C;
            end

            C: begin
                // monitor x pattern 1,0,1 on three consecutive clocks
                // x_shift holds last 3 x samples: x_shift[2] oldest, x_shift[0] newest
                // Pattern check: 3 bits equal to 3'b101
                if (x_shift == 3'b101)
                    next_state = D;
            end

            D: begin
                // g=1, monitor y up to 2 clocks
                g = 1'b1;
                // If y==1, stay in D indefinitely with g=1
                // Else if d_counter reaches 2 and no y==1, move to E
                if (y == 1'b1) begin
                    next_state = D; // stay, permanent g=1
                end else if (d_counter == 2) begin
                    next_state = E;
                end else begin
                    next_state = D; // keep counting
                end
            end

            E: begin
                // g=0 permanently until reset
                g = 1'b0;
                // Stay in E until reset
            end

            default: next_state = A;
        endcase
    end

    // Sequential logic: state update and x_shift register update, counters
    always @(posedge clk) begin
        if (resetn == 1'b0) begin
            // synchronous active low reset: go to A
            state <= A;
            x_shift <= 3'b000;
            d_counter <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift only in states before D (pattern detection states)
            if (state == C || state == B || state == A) begin
                // Shift in new x sample
                x_shift <= {x_shift[1:0], x};
            end else begin
                // hold x_shift in other states (optional)
                x_shift <= x_shift;
            end

            // Update d_counter in D state only
            if (state == D) begin
                // If y==1 reset counter (though not needed because stay in D permanently)
                // But we keep counting to check if y arrived within 2 cycles
                if (y == 1'b1) begin
                    d_counter <= 2'd0; // reset counter but we stay in D anyway
                end else if (d_counter < 2) begin
                    d_counter <= d_counter + 1;
                end
            end else begin
                d_counter <= 2'd0;
            end
        end
    end

endmodule