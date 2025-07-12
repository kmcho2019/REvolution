module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;
    reg x_prev;  // For edge detection

    // Edge detection for x
    wire x_rising = ~x_prev & x;

    // Next state logic - only transition on x rising edge in state A
    wire next_state_B = (~state_B & x_rising) | state_B;

    // Output is simply the state when x is high, inverted when in state B
    assign z = state_B ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;
            x_prev <= 1'b0;
        end else begin
            state_B <= next_state_B;
            x_prev <= x;
        end
    end

endmodule