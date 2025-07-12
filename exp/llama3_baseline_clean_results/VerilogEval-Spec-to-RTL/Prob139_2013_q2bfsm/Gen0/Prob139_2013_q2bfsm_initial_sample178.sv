module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

enum logic [2:0] {
    A, // Initial state, waiting for reset to be de-asserted
    B, // Set f to 1 for one clock cycle
    C, // Waiting for x sequence 1, 0, 1
    D, // Set g to 1, waiting for y to be 1 within 2 cycles
    E, // g remains 1
    F  // g remains 0
} state, next_state;

logic [1:0] x_sequence; // Counter for x sequence
logic [1:0] y_timer;    // Timer for y

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 0;
                g <= 0;
            end
            B: begin
                state <= C;
                f <= 1;
                g <= 0;
                x_sequence <= 0;
            end
            C: begin
                state <= C; // Stay in C until x sequence is detected
                f <= 0;
                if (x == 1) begin
                    x_sequence <= x_sequence + 1;
                    if (x_sequence == 3) begin
                        state <= D;
                        g <= 1;
                        x_sequence <= 0;
                        y_timer <= 0;
                    end
                end else begin
                    x_sequence <= 0;
                end
            end
            D: begin
                state <= D; // Stay in D until y is 1 or timer expires
                f <= 0;
                if (y) begin
                    state <= E; // y is 1, move to E
                end else if (y_timer == 2) begin
                    state <= F; // Timer expired, move to F
                end else begin
                    y_timer <= y_timer + 1;
                end
            end
            E: begin
                state <= E; // Stay in E, g remains 1
                f <= 0;
                g <= 1;
            end
            F: begin
                state <= F; // Stay in F, g remains 0
                f <= 0;
                g <= 0;
            end
            default: state <= A;
        endcase
    end
end

endmodule