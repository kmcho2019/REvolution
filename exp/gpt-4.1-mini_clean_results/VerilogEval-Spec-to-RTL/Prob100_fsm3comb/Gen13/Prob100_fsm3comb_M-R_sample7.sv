module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for readability
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // next_state logic implemented with nested conditional assignments
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A; // default fallback

    // Moore output depends only on current state
    assign out = (state == D);

endmodule