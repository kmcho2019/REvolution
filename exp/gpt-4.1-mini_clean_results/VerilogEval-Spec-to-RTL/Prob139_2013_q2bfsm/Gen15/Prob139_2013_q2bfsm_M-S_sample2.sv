module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    typedef enum logic [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 one cycle after reset release
        C = 3'd2, // monitor x pattern 101
        D = 3'd3, // g=1 one cycle pulse after pattern detected
        E = 3'd4, // monitor y for 2 cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;
    reg [1:0] y_count;  // counts cycles in E to monitor y

    // Sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift in all states except reset and A
            if (state != A && state != B) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // y_count increments only in E
            if (state == E)
                y_count <= y_count + 1'b1;
            else
                y_count <= 2'd0;
        end
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
                // After one cycle of f=1, move to monitoring x
                next_state = C;
            end

            C: begin
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // one cycle pulse of g=1
                next_state = E;
            end

            E: begin
                if (y == 1'b1)
                    next_state = F; // y detected, hold g=1 permanently
                else if (y_count == 2'd1)
                    next_state = G; // y not detected in 2 cycles, g=0 permanently
                else
                    next_state = E; // keep monitoring
            end

            F: begin
                next_state = F; // hold g=1 permanently
            end

            G: begin
                next_state = G; // hold g=0 permanently
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule