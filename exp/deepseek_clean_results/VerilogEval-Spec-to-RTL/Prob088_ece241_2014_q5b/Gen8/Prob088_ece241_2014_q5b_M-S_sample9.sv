module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            z <= 1'b0;
        end else begin
            state_A <= state_A & ~x;
            state_B <= state_B | (state_A & x);
            z <= state_A ? x : ~x;
        end
    end

endmodule