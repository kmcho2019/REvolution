module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Next state logic (combinational)
    always @(*) begin
        // Default next states to 0
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        if (state_A) begin
            if (r[0])
                next_B = 1'b1;
            else if (r[1])
                next_C = 1'b1;
            else if (r[2])
                next_D = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_B) begin
            if (r[0])
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_C) begin
            if (r[1])
                next_C = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_D) begin
            if (r[2])
                next_D = 1'b1;
            else
                next_A = 1'b1;
        end else begin
            // Safety fallback to A
            next_A = 1'b1;
        end
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
        end
    end

    // Outputs directly from state bits
    assign g = {state_D, state_C, state_B};

endmodule