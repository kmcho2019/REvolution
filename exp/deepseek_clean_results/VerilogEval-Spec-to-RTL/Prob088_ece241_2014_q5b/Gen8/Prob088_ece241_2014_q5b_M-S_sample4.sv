module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state bit: 0 = A, 1 = B
    reg state;

    // Next state logic: stay in B once entered, or go to B if x=1 in A
    wire next_state = state | (x & ~state);

    // Output logic: z = x in A, ~x in B
    assign z = state ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
        end
        else begin
            state <= next_state;
        end
    end

endmodule