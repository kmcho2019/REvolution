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
        C = 3'd2, // monitor x pattern 1,0,1 in 3 successive samples
        D = 3'd3, // one cycle g=1 pulse right after pattern detected
        E = 3'd4, // monitor y for 2 cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Shift register for last 3 samples of x
    reg [2:0] x_shift;

    // Counter for monitoring y (in state E)
    reg [1:0] y_counter, next_y_counter;

    // Sequential logic: state, x_shift, y_counter
    always @(posedge clk) begin
        if (!resetn) begin
            state     <= A;
            x_shift   <= 3'b000;
            y_counter <= 2'd0;
        end else begin
            state <= next_state;

            // Shift in x only in state C
            if (state == C) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            y_counter <= next_y_counter;
        end
    end

    // Next state and y_counter combinational logic
    always @(*) begin
        next_state = state;
        next_y_counter = y_counter;

        case(state)
            A: begin
                // Wait here as long as resetn is low; when resetn=1, go to B next
                next_state = B;
                next_y_counter = 2'd0;
            end
            B: begin
                // f=1 for one cycle, then move to pattern monitoring
                next_state = C;
                next_y_counter = 2'd0;
            end
            C: begin
                // Shift register updated; wait for pattern 101
                if (x_shift == 3'b101)
                    next_state = D;  // Pattern detected, pulse g
                else
                    next_state = C;
                next_y_counter = 2'd0;
            end
            D: begin
                // One cycle g=1 pulse; then start y monitoring (2 cycles)
                next_state = E;
                next_y_counter = 2'd0;
            end
            E: begin
                // Monitor y for at most 2 cycles with g=1
                if (y == 1'b1) begin
                    next_state = F; // y=1 detected, g=1 permanently
                    next_y_counter = 2'd0;
                end else if (y_counter == 2'd1) begin
                    // Monitored two cycles without y=1
                    next_state = G; // g=0 permanently
                    next_y_counter = 2'd0;
                end else begin
                    // Increment counter and stay in E
                    next_state = E;
                    next_y_counter = y_counter + 1'b1;
                end
            end
            F: begin
                // g=1 permanently until reset
                next_state = F;
                next_y_counter = 2'd0;
            end
            G: begin
                // g=0 permanently until reset
                next_state = G;
                next_y_counter = 2'd0;
            end
            default: begin
                next_state = A;
                next_y_counter = 2'd0;
            end
        endcase
    end

    // Outputs: Moore FSM outputs depend only on current state
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule