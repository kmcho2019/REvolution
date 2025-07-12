module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0 = A, 1 = B

    // Next state logic
    wire next_state = (state == 0) ? x : 1'b1;

    // Output logic - XOR with state
    assign z = x ^ state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
        end
        else begin
            state <= next_state;
        end
    end

endmodule