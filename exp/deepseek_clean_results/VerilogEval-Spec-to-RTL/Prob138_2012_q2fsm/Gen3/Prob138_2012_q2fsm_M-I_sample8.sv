module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 states)
    parameter [5:0] A = 6'b000001;
    parameter [5:0] B = 6'b000010;
    parameter [5:0] C = 6'b000100;
    parameter [5:0] D = 6'b001000;
    parameter [5:0] E = 6'b010000;
    parameter [5:0] F = 6'b100000;

    reg [5:0] state;

    // State transitions using case statement
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (1'b1) // synthesis parallel_case
                state[A]: state <= w ? B : A;
                state[B]: state <= w ? C : D;
                state[C]: state <= w ? E : D;
                state[D]: state <= w ? F : A;
                state[E]: state <= w ? E : D;
                state[F]: state <= w ? C : D;
                default: state <= A;
            endcase
        end
    end

    // Output z is high for states E and F (bits 4 and 5)
    assign z = state[4] | state[5];

endmodule