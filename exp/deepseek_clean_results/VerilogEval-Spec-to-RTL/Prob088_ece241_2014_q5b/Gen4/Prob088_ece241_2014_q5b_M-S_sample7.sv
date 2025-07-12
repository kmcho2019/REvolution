module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;

    // Output is XOR of state and input
    assign z = state_B ^ x;

    // Next state: stay in B or move to B when x=1
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end
        else begin
            state_B <= state_B | (~state_B & x);
        end
    end

endmodule