module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding: 6 states, each represented by one bit in a 6-bit vector
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        // Default next_state to all zeros to catch errors, will be overridden
        next_state = 6'b0;

        case (1'b1) // Priority encoding: which state bit is high?
            state[0]: next_state = w ? B : A; // A
            state[1]: next_state = w ? C : D; // B
            state[2]: next_state = w ? E : D; // C
            state[3]: next_state = w ? F : A; // D
            state[4]: next_state = w ? E : D; // E
            state[5]: next_state = w ? C : D; // F
            default:  next_state = A;          // Failsafe
        endcase
    end

    // Output logic: z=1 in states E and F, i.e., bit4 or bit5 set
    assign z = state[4] | state[5];

endmodule