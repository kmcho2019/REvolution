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
        B = 3'd1, // f=1 one cycle after reset deassert
        C = 3'd2, // monitor x pattern 101 continuously
        D = 3'd3, // g=1 one cycle pulse after pattern detected
        E = 3'd4, // monitor y for up to two cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;
    reg [1:0] y_timer;  // counts y monitoring cycles (0,1,2)

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_timer <= 2'd0;
        end else begin
            state <= next_state;

            // Update shift register every cycle except reset
            if (state != A)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            if (state == E)
                y_timer <= y_timer + 1;
            else
                y_timer <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                // Stay in A while reset asserted
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After asserting f=1 one cycle, move to C
                next_state = C;
            end

            C: begin
                // Look for pattern 101 in x_shift
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // One cycle g=1 pulse after pattern detected
                next_state = E;
            end

            E: begin
                // Monitor y up to two cycles
                if (y == 1'b1)
                    next_state = F; // y=1 detected, g=1 permanently
                else if (y_timer == 2'd1)
                    next_state = G; // y=0 for two cycles, g=0 permanently
                else
                    next_state = E; // keep monitoring
            end

            F: begin
                // g=1 permanently
                next_state = F;
            end

            G: begin
                // g=0 permanently
                next_state = G;
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule