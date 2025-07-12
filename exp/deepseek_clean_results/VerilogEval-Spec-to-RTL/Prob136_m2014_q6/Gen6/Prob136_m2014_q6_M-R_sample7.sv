module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding (same Gray code)
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b011,
                    D = 3'b010,
                    E = 3'b110,
                    F = 3'b100;

    reg [2:0] current_state, next_state;

    // Combinational state transition logic
    assign next_state = 
        (current_state == A) ? (w ? A : B) :
        (current_state == B) ? (w ? D : C) :
        (current_state == C) ? (w ? D : E) :
        (current_state == D) ? (w ? A : F) :
        (current_state == E) ? (w ? D : E) :
        (current_state == F) ? (w ? D : C) :
        A;  // default

    // Sequential state register
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (combinational)
    assign z = next_state[2];  // Output based on next state

endmodule