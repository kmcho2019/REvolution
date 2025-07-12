module TopModule(
    input  [5:0] y,   // current state one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state bit for B (y[1])
    output       Y4   // next state bit for D (y[3])
);

    // State encodings for clarity
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] next_state;

    always @(*) begin
        // Default no next state
        next_state = 6'b0;

        // State A transitions
        if (y == A) begin
            if (w == 1'b0)
                next_state = B;
            else
                next_state = A;
        end

        // State B transitions
        else if (y == B) begin
            if (w == 1'b0)
                next_state = C;
            else
                next_state = D;
        end

        // State C transitions
        else if (y == C) begin
            if (w == 1'b0)
                next_state = E;
            else
                next_state = D;
        end

        // State D transitions
        else if (y == D) begin
            if (w == 1'b0)
                next_state = F;
            else
                next_state = A;
        end

        // State E transitions
        else if (y == E) begin
            if (w == 1'b0)
                next_state = E;
            else
                next_state = D;
        end

        // State F transitions
        else if (y == F) begin
            if (w == 1'b0)
                next_state = C;
            else
                next_state = D;
        end

        else begin
            // Undefined state, default to A
            next_state = A;
        end
    end

    // Output next state bits for y[1] (B) and y[3] (D)
    assign Y2 = next_state[1];
    assign Y4 = next_state[3];

endmodule