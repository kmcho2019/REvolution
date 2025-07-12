module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Synchronous reset and state register
    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1'b0;
            state_B <= 1'b1; // reset to state B
            out <= 1'b1;     // output for B state
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
            // Output depends only on state_B because:
            // out=1 in B, out=0 in A
            out <= state_B;
        end
    end

    // Next state combinational logic
    always @(*) begin
        // Default no transitions
        next_state_A = 1'b0;
        next_state_B = 1'b0;

        // From B
        if (state_B) begin
            if (in == 1'b0) begin
                next_state_A = 1'b1;
            end else begin
                next_state_B = 1'b1;
            end
        end

        // From A
        else if (state_A) begin
            if (in == 1'b0) begin
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b1;
            end
        end
    end

endmodule