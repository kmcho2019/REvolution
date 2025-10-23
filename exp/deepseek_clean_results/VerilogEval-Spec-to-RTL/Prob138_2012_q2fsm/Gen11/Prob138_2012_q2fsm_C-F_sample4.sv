module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimal state encoding:
    // - Gray-code like transitions between states
    // - z output is MSB (states E and F have this bit set)
    localparam [2:0] A = 3'b000,  // z=0
                     B = 3'b001,  // z=0
                     C = 3'b011,  // z=0
                     D = 3'b010,  // z=0
                     E = 3'b110,  // z=1
                     F = 3'b111;  // z=1

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;  // Handle undefined states
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is simply the MSB of the state register
    assign z = state[2];

endmodule