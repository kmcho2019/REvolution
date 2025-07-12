module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding: each state is one bit
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (1'b1) // one-hot encoded states
            current_state[0]: next_state = w ? B : A;  // A
            current_state[1]: next_state = w ? C : D;  // B
            current_state[2]: next_state = w ? E : D;  // C
            current_state[3]: next_state = w ? F : A;  // D
            current_state[4]: next_state = w ? E : D;  // E
            current_state[5]: next_state = w ? C : D;  // F
            default:         next_state = A;           // safe default
        endcase
    end

    // Registered output z (Moore machine), update on clock to reduce glitches
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= (current_state == E) || (current_state == F);
    end

endmodule