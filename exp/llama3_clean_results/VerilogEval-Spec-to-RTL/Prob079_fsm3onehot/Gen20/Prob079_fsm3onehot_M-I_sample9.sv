module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Output logic remains the same as it is already optimized
    assign out = (state == D);

    // State transition logic
    // Simplify the state transition logic by reducing conditional statements
    assign next_state = (
        (state == A) ? (in ? B : A) :
        (state == B) ? B :
        (state == C) ? (in ? D : A) :
        (state == D) ? (in ? B : C) :
        4'bxxxx
    );

    // Alternatively, consider using case statement for better readability and synthesis
    // assign next_state = (
    //     (state == A) && !in ? A :
    //     (state == A) && in  ? B :
    //     (state == B)         ? B :
    //     (state == C) && !in ? A :
    //     (state == C) && in  ? D :
    //     (state == D) && !in ? C :
    //     (state == D) && in  ? B :
    //     4'bxxxx
    // );

endmodule