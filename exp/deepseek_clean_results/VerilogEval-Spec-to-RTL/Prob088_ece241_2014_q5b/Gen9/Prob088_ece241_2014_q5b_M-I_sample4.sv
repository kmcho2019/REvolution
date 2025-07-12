module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;  // state_B is implicit as ~state_A (one-hot)

    // Next state logic - simplified
    wire next_state_A = state_A & ~x;

    // Output logic optimized to XOR
    assign z = state_A ^ x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
        end
        else begin
            state_A <= next_state_A;
        end
    end

endmodule