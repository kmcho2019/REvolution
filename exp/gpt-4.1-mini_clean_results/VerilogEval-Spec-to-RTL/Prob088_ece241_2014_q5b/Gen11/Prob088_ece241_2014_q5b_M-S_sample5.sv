module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    reg state_A, state_B;

    // State update with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= state_A & ~x;
            state_B <= (state_A & x) | state_B;
        end
    end

    // Output logic: z = 1 if in A and x=1 or in B and x=0
    always @(*) begin
        z = (state_A & x) | (state_B & ~x);
    end
endmodule