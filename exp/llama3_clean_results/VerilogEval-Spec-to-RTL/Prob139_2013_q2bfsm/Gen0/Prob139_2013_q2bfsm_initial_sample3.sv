module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    // Enumerations for states
    enum logic [2:0] {A, B, C, D, E, F} state, nextState;

    // Counter to monitor clock cycles for x sequence and y detection
    logic [1:0] x_seq_counter;
    logic [1:0] y_detect_counter;

    // Flags for tracking the sequence of x and detection of y
    logic x_prev, x_prev_prev;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            x_seq_counter <= 0;
            y_detect_counter <= 0;
            x_prev <= 0;
            x_prev_prev <= 0;
        end else begin
            state <= nextState;
            case (state)
                A: begin
                    if (resetn) begin
                        nextState <= B;
                    end else begin
                        nextState <= A;
                    end
                    f <= 0;
                    g <= 0;
                end
                B: begin
                    nextState <= C;
                    f <= 1;
                    g <= 0;
                end
                C: begin
                    x_prev_prev <= x_prev;
                    x_prev <= x;
                    if (x_seq_counter == 0 && x == 1) begin
                        x_seq_counter <= 1;
                    end else if (x_seq_counter == 1 && x == 0) begin
                        x_seq_counter <= 2;
                    end else if (x_seq_counter == 2 && x == 1) begin
                        x_seq_counter <= 0;
                        nextState <= D;
                    end else begin
                        x_seq_counter <= 0;
                        nextState <= C;
                    end
                    f <= 0;
                    g <= 0;
                end
                D: begin
                    nextState <= E;
                    f <= 0;
                    g <= 1;
                end
                E: begin
                    y_detect_counter <= y_detect_counter + 1;
                    if (y == 1 || y_detect_counter == 2) begin
                        if (y == 1) begin
                            nextState <= E;
                        end else begin
                            nextState <= F;
                        end
                    end else begin
                        nextState <= E;
                    end
                    f <= 0;
                    if (y_detect_counter == 2 && y == 0) begin
                        g <= 0;
                    end else if (y == 1) begin
                        g <= 1;
                    end
                end
                F: begin
                    nextState <= F;
                    f <= 0;
                    g <= 0;
                end
                default: begin
                    nextState <= A;
                    f <= 0;
                    g <= 0;
                end
            endcase
        end
    end

endmodule