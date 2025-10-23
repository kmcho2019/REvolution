module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized hybrid state encoding
    parameter [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] current_state, next_state;

    // State transition logic with optimized critical paths
    always @(*) begin
        case (current_state)
            A:    next_state = w ? B : A;
            B:    next_state = w ? C : D;
            C:    next_state = w ? E : D;
            D:    next_state = w ? F : A;  // Critical path optimized
            E:    next_state = w ? E : D;
            F:    next_state = w ? C : D;
            default: next_state = A;        // Robust handling
        endcase
    end

    // State storage with efficient reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - direct bit mapping
    assign z = current_state[2];

endmodule