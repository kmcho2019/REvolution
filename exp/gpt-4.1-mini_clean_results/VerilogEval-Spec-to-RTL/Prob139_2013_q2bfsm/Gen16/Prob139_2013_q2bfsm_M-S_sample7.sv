module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum logic [3:0] {
        A  = 4'd0, // reset state
        B  = 4'd1, // f=1 one cycle after reset release
        C0 = 4'd2, // waiting for x=1 (pattern start)
        C1 = 4'd3, // waiting for x=0
        C2 = 4'd4, // waiting for x=1 (final)
        D  = 4'd5, // g=1 pulse one cycle after pattern detected
        E0 = 4'd6, // monitor y cycle 1 with g=1
        E1 = 4'd7, // monitor y cycle 2 with g=1
        F  = 4'd8, // hold g=1 permanently
        G  = 4'd9  // hold g=0 permanently
    } state_t;

    state_t state, next_state;

    // Sequential state update
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After one cycle f=1, start pattern detection
                next_state = C0;
            end

            C0: begin
                // Wait for x=1 to start pattern
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0;
            end

            C1: begin
                // Wait for x=0
                if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1; // stay if still 1 (wait for 0)
                else
                    next_state = C0; // pattern broken, restart
            end

            C2: begin
                // Wait for x=1 to complete pattern 1,0,1
                if (x == 1'b1)
                    next_state = D;
                else if (x == 1'b0)
                    next_state = C0; // pattern restart
                else
                    next_state = C2; // wait
            end

            D: begin
                // One cycle pulse g=1 after pattern detected
                next_state = E0;
            end

            E0: begin
                // Monitor y first cycle with g=1
                if (y == 1'b1)
                    next_state = F;
                else
                    next_state = E1;
            end

            E1: begin
                // Monitor y second cycle with g=1
                if (y == 1'b1)
                    next_state = F;
                else
                    next_state = G;
            end

            F: begin
                // hold g=1 permanently
                next_state = F;
            end

            G: begin
                // hold g=0 permanently
                next_state = G;
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case (state)
            B:   f = 1'b1;
            D,
            E0,
            E1,
            F:   g = 1'b1;
            default: begin end
        endcase
    end

endmodule