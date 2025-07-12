module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;

    // Output is XOR of state and input
    assign z = state_B ^ x;

    // Next state is current state OR (NOT current state AND x)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;
        end
        else begin
            state_B <= state_B | x;
        end
    end

endmodule