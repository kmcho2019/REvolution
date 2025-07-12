module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot encoded states: two flip-flops
    reg state_A, state_B;

    // Next-state logic
    wire next_A = state_A & ~x;          // Stay in A if x=0
    wire next_B = state_B | (state_A & x); // Stay in B once entered or from A if x=1

    // Asynchronous active-high reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Mealy output logic: z = x in A, z = ~x in B
    assign z = state_A ? x : ~x;

endmodule