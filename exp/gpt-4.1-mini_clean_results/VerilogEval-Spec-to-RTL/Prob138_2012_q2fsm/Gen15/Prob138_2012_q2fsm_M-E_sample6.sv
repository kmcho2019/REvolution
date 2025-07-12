module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding of states: 6 bits, one hot per state
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: synchronous reset and state update on posedge clk
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic using one-hot encoded states
    always @(*) begin
        case (1'b1)
            state[A]: next_state = w ? B : A;
            state[B]: next_state = w ? C : D;
            state[C]: next_state = w ? E : D;
            state[D]: next_state = w ? F : A;
            state[E]: next_state = w ? E : D;
            state[F]: next_state = w ? C : D;
            default:  next_state = A; // safe fallback
        endcase
    end

    // Output logic: z = 1 only in state E
    assign z = state[4]; // bit index 4 corresponds to E

endmodule