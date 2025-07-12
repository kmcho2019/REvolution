module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding: each state is a single bit set to 1
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        next_state = 6'b0;  // default no state (should never happen)
        case (1'b1)  // priority encoding for one-hot current state
            state[0]: next_state = (w == 1'b0) ? B : A; // A
            state[1]: next_state = (w == 1'b0) ? C : D; // B
            state[2]: next_state = (w == 1'b0) ? E : D; // C
            state[3]: next_state = (w == 1'b0) ? F : A; // D
            state[4]: next_state = (w == 1'b0) ? E : D; // E
            state[5]: next_state = (w == 1'b0) ? C : D; // F
            default: next_state = A;  // default to initial state if error
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z = 1 if in E or F (bits 4 or 5 are set)
    always @(*) begin
        z = state[4] | state[5];
    end

endmodule