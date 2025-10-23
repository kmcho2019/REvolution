module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Next state logic with optimized case statement
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = {3'b000, ~in, in, 1'b0};      // A -> A(in=0) or B(in=1)
            state[1]: next_state = {2'b00, ~in, in, 1'b0};       // B -> C(in=0) or B(in=1)
            state[2]: next_state = {~in, 2'b00, in, 1'b0};       // C -> A(in=0) or D(in=1)
            state[3]: next_state = {1'b0, ~in, in, 1'b0};        // D -> C(in=0) or B(in=1)
        endcase
    end

    // Output logic remains optimally simple
    assign out = state[3]; // Output is 1 only in state D (MSB)

endmodule