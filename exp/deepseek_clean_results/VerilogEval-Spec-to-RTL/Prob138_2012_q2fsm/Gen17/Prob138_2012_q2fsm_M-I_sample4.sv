module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: state <= w ? B : A;
                state[B]: state <= w ? C : D;
                state[C]: state <= w ? E : D;
                state[D]: state <= w ? F : A;
                state[E]: state <= w ? E : D;
                state[F]: state <= w ? C : D;
            endcase
        end
    end

    // Output is high for states E or F
    assign z = state[E] | state[F];

endmodule