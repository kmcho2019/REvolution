module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output reg   out
);

    // State encoding for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Next state logic implemented with nested ternary operators
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A;  // default fallback

    // Moore output logic implemented as combinational always block
    always @(*) begin
        case(state)
            A, B, C: out = 1'b0;
            D:       out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule