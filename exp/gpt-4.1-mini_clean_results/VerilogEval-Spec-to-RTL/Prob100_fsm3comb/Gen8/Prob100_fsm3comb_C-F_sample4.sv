module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state combinational logic using a combinational case expression inside continuous assign
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A;  // Default fallback

    // Moore output depends only on the current state (state D outputs 1)
    assign out = (state == D);

endmodule