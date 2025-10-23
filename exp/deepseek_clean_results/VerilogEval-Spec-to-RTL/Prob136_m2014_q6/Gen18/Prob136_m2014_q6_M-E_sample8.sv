module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state;

    // Parallel next state computation for all states
    wire [5:0] next_A = w ? A : B;
    wire [5:0] next_B = w ? D : C;
    wire [5:0] next_C = w ? D : E;
    wire [5:0] next_D = w ? A : F;
    wire [5:0] next_E = w ? D : E;
    wire [5:0] next_F = w ? D : C;

    // Next state selection mux
    wire [5:0] next_state = 
        (state == A) ? next_A :
        (state == B) ? next_B :
        (state == C) ? next_C :
        (state == D) ? next_D :
        (state == E) ? next_E :
        (state == F) ? next_F :
        A;  // default case

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (E and F states have z=1)
    assign z = state[4] | state[5];

endmodule