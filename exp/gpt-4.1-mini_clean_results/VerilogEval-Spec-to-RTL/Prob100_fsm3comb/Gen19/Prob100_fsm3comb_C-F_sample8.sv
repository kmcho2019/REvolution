module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    // next_state[1] and next_state[0] derived explicitly:
    // From the state table:
    // For bit 1:
    //   next_state[1] = 
    //     (state==B && in==0) | (state==C && in==1) | (state==D && in==0)
    //   Mapping states to bits:
    //     B=01 => state[1]=0 state[0]=1
    //     C=10 => state[1]=1 state[0]=0
    //     D=11 => state[1]=1 state[0]=1
    //
    // For bit 0:
    //   next_state[0] =
    //     (state==A && in==1) | (state==B && in==1) | (state==D && in==1)

    wire in_bar = ~in;
    wire s1 = state[1];
    wire s0 = state[0];

    // Define helper wires for states
    wire isA = ~s1 & ~s0;
    wire isB = ~s1 &  s0;
    wire isC =  s1 & ~s0;
    wire isD =  s1 &  s0;

    // next_state[1]:
    // next_state1 = (B & ~in) | (C & in) | (D & ~in)
    wire next_state1 = (isB & in_bar) | (isC & in) | (isD & in_bar);

    // next_state[0]:
    // next_state0 = (A & in) | (B & in) | (D & in)
    wire next_state0 = in & (isA | isB | isD);

    assign next_state = {next_state1, next_state0};

    // Moore output: only high at state D (11)
    assign out = s1 & s0;

endmodule