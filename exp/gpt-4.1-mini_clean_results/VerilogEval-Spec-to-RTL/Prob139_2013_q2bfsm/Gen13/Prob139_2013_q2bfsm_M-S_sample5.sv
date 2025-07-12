module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // reset state, f=0, g=0
        B = 3'd1, // f=1 for one cycle after reset deassertion
        C = 3'd2, // monitor x pattern 1,0,1 in successive cycles
        D = 3'd3, // one cycle g=1 pulse after pattern detection
        E = 3'd4, // monitor y for up to two cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;       // shift register for x input samples
    reg [1:0] y_count, next_y_count; // counter for y monitoring in E

    // Sequential logic: state, x_shift, y_count
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift only in C state
            if (state == C)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            y_count <= next_y_count;
        end
    end

    // Next state and y_count combinational logic
    always @(*) begin
        next_state   = state;
        next_y_count = y_count;

        case (state)
            A: begin
                // Stay in A while resetn=0, else go to B on next clock
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
                next_y_count = 2'd0;
            end

            B: begin
                // Output f=1 one cycle, then move to pattern detection C
                next_state = C;
                next_y_count = 2'd0;
            end

            C: begin
                // Shift in x each cycle; wait for pattern 101
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
                next_y_count = 2'd0;
            end

            D: begin
                // One cycle pulse g=1, then start y monitoring
                next_state = E;
                next_y_count = 2'd0;
            end

            E: begin
                // Monitor y input up to 2 cycles
                if (y == 1'b1) begin
                    next_state = F;       // y=1 detected, g=1 permanently
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // Monitored two cycles without y=1
                    next_state = G;       // g=0 permanently
                    next_y_count = 2'd0;
                end else begin
                    next_state = E;
                    next_y_count = y_count + 1'b1;
                end
            end

            F: begin
                // g=1 permanently until reset
                next_state = F;
                next_y_count = 2'd0;
            end

            G: begin
                // g=0 permanently until reset
                next_state = G;
                next_y_count = 2'd0;
            end

            default: begin
                next_state = A;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule