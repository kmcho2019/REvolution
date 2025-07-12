module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic
    assign next_state = (state == 4'b0001 &&!in)? 4'b0001 : // A to A when in=0
                       (state == 4'b0001 &&  in)? 4'b0010 : // A to B when in=1
                       (state == 4'b0010 &&!in)? 4'b0100 : // B to C when in=0
                       (state == 4'b0010 &&  in)? 4'b0010 : // B to B when in=1
                       (state == 4'b0100 &&!in)? 4'b0001 : // C to A when in=0
                       (state == 4'b0100 &&  in)? 4'b1000 : // C to D when in=1
                       (state == 4'b1000 &&!in)? 4'b0100 : // D to C when in=0
                       (state == 4'b1000 &&  in)? 4'b0010 : 4'bxxxx; // D to B when in=1

    // Output logic
    assign out = (state == 4'b1000)? 1'b1 : 1'b0; // Output is 1 only when state is D

endmodule