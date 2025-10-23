module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    parameter [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        next_state = 6'b0;
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = w ? B : A;
            state[B]: next_state = w ? C : D;
            state[C]: next_state = w ? E : D;
            state[D]: next_state = w ? F : A;
            state[E]: next_state = w ? E : D;
            state[F]: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State registers
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Pipelined output register
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= state[E] | state[F]; // Output is 1 for E or F states
        end
    end

endmodule