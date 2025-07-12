module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state;

    // Parallel next-state computation for each possible current state
    wire [5:0] next_A = w ? B : A;
    wire [5:0] next_B = w ? C : D;
    wire [5:0] next_C = w ? E : D;
    wire [5:0] next_D = w ? F : A;
    wire [5:0] next_E = w ? E : D;
    wire [5:0] next_F = w ? C : D;

    // Select the appropriate next state based on current state
    wire [5:0] next_state = ({6{state == A}} & next_A) |
                            ({6{state == B}} & next_B) |
                            ({6{state == C}} & next_C) |
                            ({6{state == D}} & next_D) |
                            ({6{state == E}} & next_E) |
                            ({6{state == F}} & next_F);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is high when in state E or F
    assign z = state[4] | state[5];  // E or F

endmodule