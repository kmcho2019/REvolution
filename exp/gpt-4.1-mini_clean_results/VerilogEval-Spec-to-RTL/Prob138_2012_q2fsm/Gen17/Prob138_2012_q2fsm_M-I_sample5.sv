module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding - 6 bits for 6 states
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state register with synchronous reset, unconditional update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic based on current state and input w
    always @(*) begin
        case (1'b1) // priority encoding using one-hot state bits
            state[0]: next_state = w ? B : A; // A
            state[1]: next_state = w ? C : D; // B
            state[2]: next_state = w ? E : D; // C
            state[3]: next_state = w ? F : A; // D
            state[4]: next_state = w ? E : D; // E
            state[5]: next_state = w ? C : D; // F
            default:  next_state = A;         // safe default
        endcase
    end

    // Output logic: z = 1 in states E and F
    always @(posedge clk) begin
        // Register output to reduce glitches and improve timing/power
        z <= (state == E) || (state == F);
    end

endmodule