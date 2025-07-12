module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic
    assign next_state = (
        (state == 4'b0001 && !in) ? 4'b0001 :  // A and in=0, next state is A
        (state == 4'b0001 && in)  ? 4'b0010 :  // A and in=1, next state is B
        (state == 4'b0010 && !in) ? 4'b0100 :  // B and in=0, next state is C
        (state == 4'b0010 && in)  ? 4'b0010 :  // B and in=1, next state is B
        (state == 4'b0100 && !in) ? 4'b0001 :  // C and in=0, next state is A
        (state == 4'b0100 && in)  ? 4'b1000 :  // C and in=1, next state is D
        (state == 4'b1000 && !in) ? 4'b0100 :  // D and in=0, next state is C
        (state == 4'b1000 && in)  ? 4'b0010 :  // D and in=1, next state is B
        4'b0000
    );

    // Output logic
    assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule