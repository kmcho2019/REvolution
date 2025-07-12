module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse after reset
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1 pulse after pattern detected
        E = 3'd4, // g=1 hold, monitor y for 2 cycles
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Registers
    logic [2:0] x_shift, next_x_shift;
    logic [1:0] y_count, next_y_count;

    // Sequential logic - state and registers update
    always_ff @(posedge clk) begin
        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'd0;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state    <= next_state;
            x_shift  <= next_x_shift;
            y_count  <= next_y_count;
            f        <= (next_state == B);    // f=1 only in B
            g        <= (next_state == D) || (next_state == E) || (next_state == F); // g=1 in D,E,F
        end
    end

    // Combinational logic - next state and next register values
    always_comb begin
        // Default assignments
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case(state)
            A: begin
                // Stay in A while resetn=0 handled in sequential block
                // When resetn=1, move to B next cycle
                next_state   = B;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            B: begin
                // One cycle f=1 pulse immediately after leaving reset
                // Next move to C
                next_state   = C;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            C: begin
                // Monitor x for pattern 1,0,1 in consecutive clock cycles
                // Shift in current x input
                next_x_shift = {x_shift[1:0], x};
                next_y_count = 2'd0;
                // Check pattern in updated shift register
                if (next_x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // g=1 pulse for one clock cycle after detecting pattern
                next_state   = E;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            E: begin
                // Hold g=1, monitor y for up to 2 clock cycles
                next_x_shift = 3'b000; // no x monitoring here
                if (y == 1'b1) begin
                    // y=1 detected within 2 cycles: hold g=1 permanently
                    next_state   = F;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // Two cycles elapsed without y=1, move to g=0 permanent
                    next_state   = G;
                    next_y_count = 2'd0;
                end else begin
                    // Increment count and stay in E
                    next_state   = E;
                    next_y_count = y_count + 1'b1;
                end
            end

            F: begin
                // g=1 permanent hold until reset
                next_state   = F;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            G: begin
                // g=0 permanent hold until reset
                next_state   = G;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                // Safety fallback
                next_state   = A;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

endmodule