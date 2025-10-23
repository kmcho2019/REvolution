module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic: one-hot transitions
    always @(*) begin
        case (1'b1)  // synthesis parallel_case full_case
            state[0]: next_state = (w == 1'b0) ? B : A;      // A
            state[1]: next_state = (w == 1'b0) ? C : D;      // B
            state[2]: next_state = (w == 1'b0) ? E : D;      // C
            state[3]: next_state = (w == 1'b0) ? F : A;      // D
            state[4]: next_state = (w == 1'b0) ? E : D;      // E
            state[5]: next_state = (w == 1'b0) ? C : D;      // F
            default: next_state = A;
        endcase
    end

    // Output logic separated: z=1 for states E or F
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= state[4] | state[5];
    end

endmodule