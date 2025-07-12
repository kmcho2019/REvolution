module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding:
    // - States with z=1 (E,F) have MSB set
    // - Gray-like encoding for minimal transitions
    localparam [2:0] A = 3'b000,  // z=0
                     B = 3'b001,  // z=0
                     C = 3'b011,  // z=0
                     D = 3'b010,  // z=0
                     E = 3'b110,  // z=1
                     F = 3'b111;  // z=1

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;  // Safe default
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output z is simply the MSB of the state
    assign z = current_state[2];

endmodule