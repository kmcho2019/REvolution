module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // State transition logic using continuous assignments with ternary operators
    assign next_state = (state == A)? (in ? B : A) :
                        (state == B)? (in ? B : C) :
                        (state == C)? (in ? D : A) :
                        (state == D)? (in ? B : C) : 4'bxxxx;

    // Alternatively, to further improve readability, we can use a case statement for the state transitions
    // always @(*) begin
    //     case (state)
    //         A: next_state = in ? B : A;
    //         B: next_state = in ? B : C;
    //         C: next_state = in ? D : A;
    //         D: next_state = in ? B : C;
    //         default: next_state = 4'bxxxx;
    //     endcase
    // end

    // Output logic
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule