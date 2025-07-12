module TopModule(
    input           clk,
    input           resetn,
    input           x,
    input           y,
    output          f,
    output          g
);

    // Define the states
    enum logic [2:0] {A, B, C, D1, D2, E} state, next_state;

    // Sequential logic
    always_ff @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic
    always_comb begin
        case (state)
            A: begin
                if (~resetn) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
                f = 0;
                g = 0;
            end
            B: begin
                next_state = C;
                f = 1;
                g = 0;
            end
            C: begin
                if (x) begin
                    next_state = C1;
                end else begin
                    next_state = C;
                end
                f = 0;
                g = 0;
            end
            C1: begin
                if (~x) begin
                    next_state = C2;
                end else begin
                    next_state = C;
                end
                f = 0;
                g = 0;
            end
            C2: begin
                if (x) begin
                    next_state = D1;
                end else begin
                    next_state = C;
                end
                f = 0;
                g = 0;
            end
            D1: begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = D2;
                end
                f = 0;
                g = 1;
            end
            D2: begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = C;
                end
                f = 0;
                g = 0;
            end
            E: begin
                next_state = E;
                f = 0;
                g = 1;
            end
            default: begin
                next_state = A;
                f = 0;
                g = 0;
            end
        endcase
    end

endmodule