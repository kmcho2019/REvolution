module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 one cycle after reset deassert
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1, monitor y for up to 2 cycles
        E = 3'd4, // g=1 permanently (y=1 detected)
        F = 3'd5  // g=0 permanently (y=1 not detected within 2 cycles)
    } state_t;

    reg [2:0] state, next_state;

    // For monitoring x pattern 1,0,1
    reg [2:0] x_shift; // shift register holding last 3 x samples

    // For counting y observation window (max 2 cycles)
    reg [1:0] y_counter;

    // FSM sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_counter <= 2'd0;
        end else begin
            state <= next_state;

            // Shift in x each cycle when in C or D, else reset
            if (state == C || state == D) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // y_counter update only in D
            if (state == D) begin
                y_counter <= y_counter + 1;
            end else begin
                y_counter <= 2'd0;
            end
        end
    end

    // FSM combinational next state and outputs
    always @(*) begin
        // Defaults
        next_state = state;
        f = 1'b0;
        g = 1'b0;

        case (state)
            A: begin
                // Reset active, stay here
                // f=0, g=0 already by default
                if (resetn) begin
                    // reset deasserted, next state B for one cycle f=1
                    next_state = B;
                end
            end
            B: begin
                // one cycle f=1
                f = 1'b1;
                g = 1'b0;
                // next state C to monitor x
                next_state = C;
            end
            C: begin
                f = 1'b0;
                g = 1'b0;
                // monitor x_shift for 3-bit pattern 1,0,1
                // x_shift[2] is oldest, x_shift[0] newest
                // pattern is: x_shift = 3'b101
                if (x_shift == 3'b101) begin
                    // pattern detected, go to D set g=1 and monitor y
                    next_state = D;
                end else begin
                    // stay in C
                    next_state = C;
                end
            end
            D: begin
                // set g=1, monitor y for max 2 cycles (y_counter)
                g = 1'b1;
                f = 1'b0;

                if (y == 1'b1) begin
                    // y detected within 2 cycles, go to E (permanent g=1)
                    next_state = E;
                end else if (y_counter == 2'd2) begin
                    // 2 cycles passed without y=1, go to F (permanent g=0)
                    next_state = F;
                end else begin
                    // keep monitoring y
                    next_state = D;
                end
            end
            E: begin
                // permanent g=1 state
                g = 1'b1;
                f = 1'b0;
                next_state = E;
            end
            F: begin
                // permanent g=0 state
                g = 1'b0;
                f = 1'b0;
                next_state = F;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule