module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding: two bits for two states
    // state_A = 1 means state A active
    // state_B = 1 means state B active
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Next state logic (combinational)
    always @(*) begin
        // Default values
        next_state_A = 1'b0;
        next_state_B = 1'b0;

        if (state_A) begin
            if (x == 1'b0) begin
                // stay in A
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end else begin
                // go to B
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        end else begin // state_B active
            // from B, stay in B regardless of x
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to state A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Output logic (Mealy): z = (A & x) | (B & ~x)
    assign z = (state_A & x) | (state_B & ~x);

endmodule