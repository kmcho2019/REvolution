module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse after reset
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1 pulse after pattern detected
        E = 3'd4, // g=1 hold, monitor y for 2 cycles
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] x_shift;   // shift register for last 3 x inputs
    reg [1:0] y_count;   // counter for y monitoring cycles in E

    // Sequential logic: state, registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'd0;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state <= next_state;

            // Update x_shift in states where x pattern is monitored (state C)
            if (state == C) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000; // Clear when not monitoring x pattern
            end

            // y_count management only in state E
            if (state == E) begin
                if (y == 1'b1) begin
                    y_count <= 2'd0; // Will transition to F, reset count
                end else begin
                    y_count <= y_count + 1'b1;
                end
            end else begin
                y_count <= 2'd0;
            end

            // Outputs assigned based on state
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;  // One cycle pulse after reset
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;  // one cycle pulse g=1 after pattern detected
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;  // hold g=1 and monitor y
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b1;  // g=1 permanent hold
                end
                G: begin
                    f <= 1'b0;
                    g <= 1'b0;  // g=0 permanent hold
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold state

        case (state)
            A: begin
                // While resetn=0, remain in A (ensured by sequential)
                // After resetn=1, move to B next clock
                next_state = B;
            end

            B: begin
                // After f=1 pulse, move to monitor x pattern
                next_state = C;
            end

            C: begin
                // Check for pattern 1,0,1 on x_shift after shifting in current x (x_shift is updated sequentially)
                // Pattern detection uses current x_shift state
                // Because x_shift shifted in current clock, this check reflects last 3 cycles properly
                if (x_shift == 3'b101) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end

            D: begin
                // one clock pulse g=1, then move to E to monitor y
                next_state = E;
            end

            E: begin
                // Monitor y for up to 2 clock cycles
                if (y == 1'b1) begin
                    next_state = F; // y=1 detected within 2 cycles, permanent g=1
                end else if (y_count == 2'd1) begin
                    // Two cycles elapsed without y=1 (since y_count increments after first cycle)
                    next_state = G; // permanent g=0
                end else begin
                    next_state = E; // keep monitoring
                end
            end

            F: begin
                // permanent g=1 hold until reset
                next_state = F;
            end

            G: begin
                // permanent g=0 hold until reset
                next_state = G;
            end

            default: begin
                next_state = A; // safety reset
            end
        endcase
    end

endmodule