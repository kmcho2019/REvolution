module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    assign next_state = (in == 1'b0) ? 
                        {D, C, B, A} :  // in=0: next_state = {D,C,B,A} means next_state[3]=D, etc.
                        {B, B, D, A};   // in=1: next_state = {B,B,D,A}

    // Decoding back to proper one-hot next_state bits:
    // next_state[0] = A transitions:
    //   in=0: from A or C (bits 0 and 2)
    // next_state[1] = B transitions:
    //   in=1: from A, B or D (bits 0,1,3)
    // next_state[2] = C transitions:
    //   in=0: from B or D (bits 1,3)
    // next_state[3] = D transitions:
    //   in=1: from C (bit 2)

    // Therefore let's assign explicitly:
    assign next_state[0] = (~in & (A | C));
    assign next_state[1] = ( in & (A | B | D));
    assign next_state[2] = (~in & (B | D));
    assign next_state[3] = ( in & C);

    assign out = D;

endmodule