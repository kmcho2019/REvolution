module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;  // Tracks if we've seen the first '1'

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;  // Reset to initial state (A)
        end else begin
            if (!seen_one && x) begin
                seen_one <= 1'b1;  // Transition to state B on first '1'
            end
            // Otherwise maintain current state
        end
    end

    // Mealy output: complement if we've seen a '1'
    assign z = seen_one ? ~x : x;

endmodule