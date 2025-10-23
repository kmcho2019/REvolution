module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

typedef enum logic [2:0] {A, B, C, D, E} state_t;
state_t current_state, next_state;

logic [1:0] x_sequence;
logic [1:0] y_counter;

always_ff @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            A: begin
                f <= 0;
                g <= 0;
            end
            B: begin
                f <= 1;
            end
            C: begin
                f <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
            end
            E: begin
                f <= 0;
                g <= 0;
            end
        endcase
        if (current_state == C) begin
            if (x) x_sequence[0] <= 1;
            else if (!x && x_sequence[0] == 1) x_sequence[1] <= 1;
            else x_sequence <= 0;
        end
        if (current_state == D) begin
            if (!y) y_counter <= y_counter + 1;
            else y_counter <= 0;
        end
    end
end

always_comb begin
    case (current_state)
        A: begin
            if (!resetn) next_state = A;
            else next_state = B;
        end
        B: next_state = C;
        C: begin
            if (x_sequence == 2'b11) next_state = D;
            else if (x_sequence[0] == 0) next_state = C;
            else next_state = C;
        end
        D: begin
            if (y || y_counter >= 2) next_state = y ? D : E;
            else next_state = D;
        end
        E: next_state = E;
    endcase
end

endmodule