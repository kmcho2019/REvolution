module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding: two flip-flops
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Next-state logic
    always @(*) begin
        // default values to avoid latches
        next_state_A = 1'b0;
        next_state_B = 1'b0;

        if (state_A) begin
            // From state A
            if (x == 1'b0) begin
                next_state_A = 1'b1; // remain in A
                next_state_B = 1'b0;
            end else begin
                next_state_A = 1'b0;
                next_state_B = 1'b1; // move to B
            end
        end else if (state_B) begin
            // From state B: always remain in B
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end else begin
            // Should never happen, default to A (safe recovery)
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end
    end

    // Output logic (Mealy): 
    // A --x=0 (z=0), x=1 (z=1)
    // B --x=0 (z=1), x=1 (z=0)
    assign z = (state_A && x) || (state_B && ~x);

    // State registers with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule