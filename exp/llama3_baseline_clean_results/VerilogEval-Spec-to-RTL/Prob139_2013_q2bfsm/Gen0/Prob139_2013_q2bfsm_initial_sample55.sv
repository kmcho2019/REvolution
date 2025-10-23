module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    enum {A, B, C, D, E} state, next_state;
    reg [1:0] x_sequence;
    reg [1:0] y_count;

    always @(*) begin
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
                if (x_sequence == 2'b101) begin
                    next_state = D;
                    x_sequence = 0;
                end else begin
                    next_state = C;
                    x_sequence = {x_sequence[0], x};
                end
                f = 0;
                g = 0;
            end
            D: begin
                if (y_count < 2) begin
                    if (y) begin
                        next_state = D;
                        y_count = 0;
                    end else begin
                        next_state = D;
                        y_count = y_count + 1;
                    end
                end else begin
                    next_state = E;
                end
                f = 0;
                g = 1;
            end
            E: begin
                next_state = E;
                f = 0;
                g = 0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            x_sequence <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;
        end
    end

endmodule