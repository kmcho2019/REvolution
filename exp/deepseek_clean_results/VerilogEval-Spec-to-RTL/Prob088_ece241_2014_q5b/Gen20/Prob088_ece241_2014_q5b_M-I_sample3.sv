module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;  // Only need to track one state in one-hot encoding

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
        end else begin
            state_A <= state_A & ~x;
        end
    end

    assign z = (~state_A) ^ x;  // Equivalent to: state_A ? x : ~x

endmodule