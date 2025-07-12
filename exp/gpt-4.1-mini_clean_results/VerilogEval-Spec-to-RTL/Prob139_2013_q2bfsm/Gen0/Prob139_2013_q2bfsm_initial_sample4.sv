module TopModule (
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
        B = 3'd1, // output f=1 for one cycle
        C0 = 3'd2, // monitor x for pattern 1 (first bit)
        C1 = 3'd3, // monitor x for pattern 0 (second bit)
        C2 = 3'd4, // monitor x for pattern 1 (third bit)
        D = 3'd5,  // g=1 and monitor y for 2 cycles (counter)
        E = 3'd6,  // g=1 permanently
        F = 3'd7   // g=0 permanently
    } state_t;

    reg [2:0] state, next_state;

    reg [1:0] y_count; // counts cycles in state D (max 2 cycles)

    // Sequential state update and synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            y_count <= 2'b00;
        end else begin
            state <= next_state;
            // y_count updates only in state D
            if (state == D) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 2'b00;
            end
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // default outputs
        f = 0;
        g = 0;
        next_state = state;

        case (state)
            A: begin
                // stay here on reset asserted, on release go to B
                if (resetn) begin
                    next_state = B;
                end
            end

            B: begin
                // output f=1 for one cycle
                f = 1;
                next_state = C0;
            end

            C0: begin
                // wait for x=1 to start pattern
                // pattern start: x=1
                if (x == 1'b1) begin
                    next_state = C1;
                end else begin
                    // keep waiting
                    next_state = C0;
                end
            end

            C1: begin
                // second bit of pattern must be 0
                if (x == 1'b0) begin
                    next_state = C2;
                end else if (x == 1'b1) begin
                    // restart pattern because first bit is 1 again
                    next_state = C1;
                end else begin
                    next_state = C0; // fallback
                end
            end

            C2: begin
                // third bit of pattern must be 1
                if (x == 1'b1) begin
                    // pattern matched 1,0,1
                    next_state = D;
                end else if (x == 1'b0) begin
                    // pattern breaks, restart
                    next_state = C0;
                end else begin
                    next_state = C0;
                end
            end

            D: begin
                // g=1, monitor y for two cycles max
                g = 1;
                if (y == 1'b1) begin
                    next_state = E; // maintain g=1 permanently
                end else begin
                    if (y_count == 2'd1) begin
                        // one cycle done, next cycle is last chance
                        next_state = D;
                    end else if (y_count == 2'd2) begin
                        // 2 cycles done, no y=1 detected, go to F
                        next_state = F;
                    end else begin
                        next_state = D;
                    end
                end
            end

            E: begin
                // g=1 permanently
                g = 1;
                next_state = E;
            end

            F: begin
                // g=0 permanently
                g = 0;
                next_state = F;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule