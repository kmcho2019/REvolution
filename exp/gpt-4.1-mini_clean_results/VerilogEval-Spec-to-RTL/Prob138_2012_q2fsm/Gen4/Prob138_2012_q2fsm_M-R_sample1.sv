module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding
    reg A, B, C, D, E, F;
    reg A_next, B_next, C_next, D_next, E_next, F_next;

    // Sequential logic: state registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            E <= 1'b0;
            F <= 1'b0;
        end else begin
            A <= A_next;
            B <= B_next;
            C <= C_next;
            D <= D_next;
            E <= E_next;
            F <= F_next;
        end
    end

    // Combinational next state logic using one-hot encoding and continuous assignments
    always @(*) begin
        // Default next states zeroed
        A_next = 1'b0;
        B_next = 1'b0;
        C_next = 1'b0;
        D_next = 1'b0;
        E_next = 1'b0;
        F_next = 1'b0;

        // From state A
        if (A) begin
            A_next = ~w;
            B_next = w;
        end
        // From state B
        else if (B) begin
            C_next = w;
            D_next = ~w;
        end
        // From state C
        else if (C) begin
            E_next = w;
            D_next = ~w;
        end
        // From state D
        else if (D) begin
            F_next = w;
            A_next = ~w;
        end
        // From state E
        else if (E) begin
            E_next = w;
            D_next = ~w;
        end
        // From state F
        else if (F) begin
            C_next = w;
            D_next = ~w;
        end
        else begin
            // Safety fallback to reset state
            A_next = 1'b1;
        end
    end

    // Output logic: z=1 only in states E and F (continuous assignment)
    assign z = E | F;

endmodule