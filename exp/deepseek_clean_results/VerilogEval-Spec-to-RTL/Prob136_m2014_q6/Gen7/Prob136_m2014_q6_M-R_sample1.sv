module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b011,
                    D = 3'b010,
                    E = 3'b110,
                    F = 3'b111;

    reg [2:0] current_state;

    // Next state logic using continuous assignments
    wire [2:0] next_state_A = w ? A : B;
    wire [2:0] next_state_B = w ? D : C;
    wire [2:0] next_state_C = w ? D : E;
    wire [2:0] next_state_D = w ? A : F;
    wire [2:0] next_state_E = w ? D : E;
    wire [2:0] next_state_F = w ? D : C;

    wire [2:0] next_state = 
        (current_state == A) ? next_state_A :
        (current_state == B) ? next_state_B :
        (current_state == C) ? next_state_C :
        (current_state == D) ? next_state_D :
        (current_state == E) ? next_state_E :
        (current_state == F) ? next_state_F :
        A;  // default case

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z=1 for states E (110) and F (111)
    // This checks bits [2:1] == 2'b11
    assign z = current_state[2] & current_state[1];

endmodule