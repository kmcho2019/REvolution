module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding with minimal transitions and simple output
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;  // 000→001 or stay
            B: next_state = w ? C : D;  // 001→011 or 010
            C: next_state = w ? E : D;  // 011→110 or 010
            D: next_state = w ? F : A;  // 010→111 or 000
            E: next_state = w ? E : D;  // 110→110 or 010
            F: next_state = w ? C : D;  // 111→011 or 010
            default: next_state = A;    // Handle undefined states
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is MSB of state (E and F have MSB=1)
    assign z = state[2];

endmodule