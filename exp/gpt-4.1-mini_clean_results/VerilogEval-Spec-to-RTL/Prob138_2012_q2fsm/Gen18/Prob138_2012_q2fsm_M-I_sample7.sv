module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot state encoding: each state is a bit in a 6-bit vector
    // Bit positions: [5:F][4:E][3:D][2:C][1:B][0:A]
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: synchronous reset to A
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic based on current state and input w
    always @(*) begin
        // Default next_state all zero
        next_state = 6'b000000;

        case (1'b1)  // one-hot decode
            state[0]: next_state = w ? B : A;     // A
            state[1]: next_state = w ? C : D;     // B
            state[2]: next_state = w ? E : D;     // C
            state[3]: next_state = w ? F : A;     // D
            state[4]: next_state = w ? E : D;     // E
            state[5]: next_state = w ? C : D;     // F
            default:  next_state = A;              // safe default
        endcase
    end

    // Output logic: z = 1 when in E or F states
    assign z = state[4] | state[5];

endmodule