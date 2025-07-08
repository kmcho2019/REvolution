module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4
    } state_t;

    state_t state, next_state;

    // For detecting the pattern 1,0,1 in x over three cycles:
    // We'll keep a 3-bit shift register of x inputs.
    reg [2:0] x_shift;

    // For counting cycles while monitoring y in state D
    reg [1:0] y_count;  // counts 0,1,2 cycles after entering D

    // State register and synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Shift in current x on every clock except state A and B (to keep consistent)
            // Actually, let's shift x every cycle except in A (reset state), to detect pattern properly
            if (state != A) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // Update y_count only in D state
            if (state == D) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                if (resetn)
                    next_state = B;
            end
            B: begin
                // After outputting f=1 one cycle, go to C
                next_state = C;
            end
            C: begin
                // Detect pattern 101 on x_shift[2:0]
                // pattern is MSB first: x_shift[2] = oldest, x_shift[0] = newest
                // pattern to detect: 1 0 1
                if (x_shift == 3'b101)
                    next_state = D;
            end
            D: begin
                // While g=1 monitor y for up to two cycles
                // y_count counts cycles in D starting from 0

                if (y == 1'b1) begin
                    // y=1 detected within allowed time, remain in D permanently
                    next_state = D;
                end else if (y_count >= 2) begin
                    // two cycles elapsed without y=1, move to E (g=0 permanently)
                    next_state = E;
                end else begin
                    // wait for y or timeout
                    next_state = D;
                end
            end
            E: begin
                // g=0 permanently until reset
                // stay in E
                next_state = E;
            end
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        // defaults
        f = 1'b0;
        g = 1'b0;

        case (state)
            A: begin
                f = 1'b0;
                g = 1'b0;
            end
            B: begin
                f = 1'b1; // one cycle pulse on f after reset deasserted
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
                g = 1'b0;
            end
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule