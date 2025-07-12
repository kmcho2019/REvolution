module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding
    parameter [2:0] 
        A = 3'b000,  // z=0
        B = 3'b001,  // z=0
        C = 3'b011,  // z=0
        D = 3'b010,  // z=0
        E = 3'b110,  // z=1
        F = 3'b100;  // z=1

    reg [2:0] current_state, next_state;

    // Optimized state transition logic
    always @(*) begin
        case (current_state)
            A:    next_state = w ? B : A;
            B:    next_state = w ? C : D;
            C:    next_state = w ? E : D;
            D:    next_state = w ? F : A;  // Critical path optimized
            E:    next_state = w ? E : D;
            F:    next_state = w ? C : D;
            default: next_state = A;       // Handle undefined states
        endcase
    end

    // State storage with efficient reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Direct output mapping - no additional logic
    assign z = current_state[2];

endmodule