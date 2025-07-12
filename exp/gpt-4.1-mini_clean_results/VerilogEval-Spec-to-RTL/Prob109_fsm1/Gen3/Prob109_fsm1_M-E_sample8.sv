module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding: state bits
    reg A, B;
    reg next_A, next_B;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            A <= 1'b0;
            B <= 1'b1;  // Reset state to B
        end else begin
            A <= next_A;
            B <= next_B;
        end
    end

    // Next state logic for one-hot FSM
    always @(*) begin
        // Default next states to zero
        next_A = 1'b0;
        next_B = 1'b0;

        if (B) begin
            // From B: input 0 -> A, input 1 -> B
            if (in == 1'b0)
                next_A = 1'b1;
            else
                next_B = 1'b1;
        end else if (A) begin
            // From A: input 0 -> B, input 1 -> A
            if (in == 1'b0)
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else begin
            // Safety default: go to B if no state is active
            next_B = 1'b1;
        end
    end

    // Moore output logic based on active state bit
    assign out = B;  // Output 1 for B, 0 for A

endmodule