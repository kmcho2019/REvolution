module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_bit;  // 0=A, 1=B

    // Optimized next state logic - sticky behavior when x=1
    wire next_state = state_bit | x;

    // Most efficient output logic
    assign z = x ^ state_bit;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_bit <= 1'b0;  // Reset to state A
        end
        else begin
            state_bit <= next_state;
        end
    end

endmodule