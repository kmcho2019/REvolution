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
                    F = 3'b100;

    reg [2:0] state, next_state;

    // Combinational next-state logic
    assign next_state = 
        (state == A) ? (w ? A : B) :
        (state == B) ? (w ? D : C) :
        (state == C) ? (w ? D : E) :
        (state == D) ? (w ? A : F) :
        (state == E) ? (w ? D : E) :
        (state == F) ? (w ? D : C) :
        A;  // default case

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    assign z = state[2];

endmodule