module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state bits
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Next state logic combinational
    always @(*) begin
        // Default next states to 0
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        if (state_A) begin
            next_A = (in == 1'b0);
            next_B = (in == 1'b1);
        end
        else if (state_B) begin
            next_C = (in == 1'b0);
            next_B = (in == 1'b1);
        end
        else if (state_C) begin
            next_A = (in == 1'b0);
            next_D = (in == 1'b1);
        end
        else if (state_D) begin
            next_C = (in == 1'b0);
            next_B = (in == 1'b1);
        end
        else begin
            // Defensive: if no state is active, go to A
            next_A = 1'b1;
        end
    end

    // State registers with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
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

    // Output assigned from state_D (Moore output)
    assign out = state_D;

endmodule