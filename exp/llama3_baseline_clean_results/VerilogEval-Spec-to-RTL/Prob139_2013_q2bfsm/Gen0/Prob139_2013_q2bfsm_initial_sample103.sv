module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// States
enum logic [2:0] {A, B, C, D, E} state, next_state;

// Counter for states C and D
logic [1:0] counter;

// Flag to detect x sequence
logic x_seq_detected;

// Flag to detect y within 2 cycles
logic y_detected;

always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        counter <= 0;
        x_seq_detected <= 0;
        y_detected <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        f <= (state == B) ? 1 : 0;
        g <= (state == D) ? 1 : (state == E) ? 0 : 0;

        case (state)
            A: begin
                // Stay in A when reset is asserted
                next_state <= A;
            end
            B: begin
                // Transition to C after one clock cycle
                next_state <= C;
            end
            C: begin
                // Monitor x input for sequence 1, 0, 1
                if (counter == 0 && x == 1) begin
                    counter <= counter + 1;
                end else if (counter == 1 && x == 0) begin
                    counter <= counter + 1;
                end else if (counter == 2 && x == 1) begin
                    counter <= 0;
                    x_seq_detected <= 1;
                end else if (x_seq_detected) begin
                    next_state <= D;
                    x_seq_detected <= 0;
                end else begin
                    counter <= 0;
                end
                next_state <= C;
            end
            D: begin
                // Set g to 1 and monitor y input
                if (y == 1) begin
                    y_detected <= 1;
                end
                if (y_detected || counter == 2) begin
                    if (y_detected) begin
                        next_state <= D;
                    end else begin
                        next_state <= E;
                    end
                end else begin
                    counter <= counter + 1;
                    next_state <= D;
                end
            end
            E: begin
                // Stay in E permanently
                next_state <= E;
            end
            default: begin
                next_state <= A;
            end
        endcase
    end
end

always_comb begin
    case (state)
        A: next_state = (resetn) ? B : A;
        default: next_state = state;
    endcase
end

endmodule