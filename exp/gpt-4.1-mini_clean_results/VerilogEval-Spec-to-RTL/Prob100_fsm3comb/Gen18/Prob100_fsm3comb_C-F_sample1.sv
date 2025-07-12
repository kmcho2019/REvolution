module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding parameters
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    // Next state combinational logic using continuous assignment with a case expression
    // This style avoids functions while keeping the code clear and synthesis-friendly.
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A;  // Default fallback for safety

    // Output logic: 1 only in state D, detected by bitwise AND of state bits
    assign out = state[1] & state[0];

endmodule