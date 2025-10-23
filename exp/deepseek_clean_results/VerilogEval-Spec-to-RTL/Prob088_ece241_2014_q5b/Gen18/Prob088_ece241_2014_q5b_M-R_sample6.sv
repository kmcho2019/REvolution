module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State register (one-hot, but we only need to track one bit)
    reg state_A;

    // State transitions and output are purely combinational
    wire next_state_A = state_A ? ~x : 1'b0;
    assign z = state_A ? x : ~x;

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= next_state_A;
        end
    end

endmodule