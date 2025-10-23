module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states (6 states)
    // Each bit corresponds to a state: bit0=A, bit1=B, ..., bit5=F
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous reset (active high)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        // Default: hold current state (should never be defaulted in one-hot FSM)
        next_state = 6'b0;

        case (1'b1)  // one-hot state decode
            state[0]: next_state = w ? B : A;   // A
            state[1]: next_state = w ? C : D;   // B
            state[2]: next_state = w ? E : D;   // C
            state[3]: next_state = w ? F : A;   // D
            state[4]: next_state = w ? E : D;   // E
            state[5]: next_state = w ? C : D;   // F
            default:  next_state = A;            // Safety fallback
        endcase
    end

    // Output logic: z=1 when in state E or F
    assign z = state[4] | state[5];

endmodule