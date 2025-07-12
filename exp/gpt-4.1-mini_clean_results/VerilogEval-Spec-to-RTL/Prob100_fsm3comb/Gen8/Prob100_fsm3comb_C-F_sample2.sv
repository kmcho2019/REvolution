module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for readability
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Output logic: out = 1 only in state D
    assign out = (state == D);

    // Next state logic with ternary operators and state encoding for clarity
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A; // default fallback

endmodule