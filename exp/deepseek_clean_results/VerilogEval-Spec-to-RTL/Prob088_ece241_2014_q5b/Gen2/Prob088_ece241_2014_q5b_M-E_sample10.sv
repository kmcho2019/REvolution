module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Transition tracker register (1 when we've seen first '1')
    reg seen_first_one;

    // Next state logic - track if we've seen first '1' transition
    wire next_seen = seen_first_one | x;

    // Output logic - z is x when in state A, ~x when in state B
    assign z = seen_first_one ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_first_one <= 1'b0;  // Reset to state A
        end
        else begin
            seen_first_one <= next_seen;
        end
    end

endmodule