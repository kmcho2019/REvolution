module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Next state combinational signals
    wire next_A, next_B;

    // Next state logic
    assign next_A = state_A & (~x);
    assign next_B = state_B | (state_A & x);

    // Asynchronous active-high reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Mealy output logic: z = (state_A & x) | (state_B & ~x);
    assign z = (state_A & x) | (state_B & ~x);

endmodule