module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for readability
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Next state logic using continuous assignment with nested ternary operators
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A;  // default safe fallback

    // Output logic: output = 1 only in state D
    assign out = (state == D);

endmodule