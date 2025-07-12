module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Break down next_state logic into explicit cases
    assign next_state = (
        (state == 4'b0001 && in == 1'b0) ? 4'b0001 :
        (state == 4'b0001 && in == 1'b1) ? 4'b0010 :
        (state == 4'b0010 && in == 1'b0) ? 4'b0100 :
        (state == 4'b0010 && in == 1'b1) ? 4'b0010 :
        (state == 4'b0100 && in == 1'b0) ? 4'b0001 :
        (state == 4'b0100 && in == 1'b1) ? 4'b1000 :
        (state == 4'b1000 && in == 1'b0) ? 4'b0100 :
        (state == 4'b1000 && in == 1'b1) ? 4'b0010 : 4'bxxxx
    );

    // Simplify output logic based on the state transition table
    assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule