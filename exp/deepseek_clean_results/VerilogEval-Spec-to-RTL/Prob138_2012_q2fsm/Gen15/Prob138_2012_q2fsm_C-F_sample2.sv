module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-like state encoding with z=state[2]
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b100;

    reg [2:0] current_state, next_state;

    // Hybrid state transition logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;  // Optimized frequent transition
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: begin
                if (w) next_state = F;  // Critical path optimization
                else next_state = A;
            end
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;    // Handle undefined states
        endcase
    end

    // State storage with compact reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - direct bit check (E and F have state[2]=1)
    assign z = current_state[2];

endmodule