module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;

    // State transition: stay in B once entered, or enter B from A when x=1
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;
        end
        else begin
            state_B <= state_B | (~state_B & x);
        end
    end

    // Output logic: z = x when in A (state_B=0), ~x when in B (state_B=1)
    assign z = x ^ state_B;

endmodule