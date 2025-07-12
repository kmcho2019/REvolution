module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Next state logic (simplified)
    wire next_A = state_A & ~x;
    wire next_B = ~next_A;  // Complement of next_A since only two states

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Output logic (Mealy)
    // z = x in A; z = ~x in B
    assign z = state_A ? x : ~x;

endmodule