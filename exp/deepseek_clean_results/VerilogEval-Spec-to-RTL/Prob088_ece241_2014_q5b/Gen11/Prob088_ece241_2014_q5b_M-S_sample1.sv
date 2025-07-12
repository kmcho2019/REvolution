module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;

    // State transition: stay in A until x=1, then stay in B forever
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
        end
        else if (state_A) begin
            state_A <= ~x;
        end
    end

    // Output logic
    assign z = state_A ? x : ~x;

endmodule