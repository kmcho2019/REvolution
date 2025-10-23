module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;

    // Next state logic - set state_B when x=1 in state A (state_B=0)
    wire next_state_B = state_B | (~state_B & x);

    // Output logic
    assign z = state_B ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule