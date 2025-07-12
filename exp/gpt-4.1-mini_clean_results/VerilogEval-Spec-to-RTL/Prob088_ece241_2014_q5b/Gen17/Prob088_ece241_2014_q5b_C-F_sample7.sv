module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding registers
    reg state_A, state_B;

    // Next state combinational logic
    wire next_A = state_A & ~x;
    wire next_B = state_B | (state_A & x);

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Mealy output logic: z = x in A, else ~x in B
    assign z = state_A ? x : ~x;

endmodule