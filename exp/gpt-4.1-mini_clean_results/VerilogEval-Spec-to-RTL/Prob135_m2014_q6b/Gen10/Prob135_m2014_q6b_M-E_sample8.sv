module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // State encoding:
    // A = 000, B = 001, C = 010, D = 011, E = 100, F = 101
    // Derive next y[1] based on given transitions for each state and input

    // next y[1] logic summary from FSM:
    // A(000): next y[1]=0 (both inputs)
    // B(001): next y[1]=1 if input=0 else 1
    // C(010): next y[1]=1 if w=0 else 1
    // D(011): next y[1]=1 if w=0 else 0
    // E(100): next y[1]=0 if w=0 else 1
    // F(101): next y[1]=1 if w=0 else 1

    // Implement Boolean expression for next y[1]:
    // next_y1 = (B & ~w) | (C) | (D & ~w) | (E & w) | (F);

    wire isB = (~y[2]) & (~y[1]) & y[0];
    wire isC = (~y[2]) & y[1] & (~y[0]);
    wire isD = (~y[2]) & y[1] & y[0];
    wire isE = y[2] & (~y[1]) & (~y[0]);
    wire isF = y[2] & (~y[1]) & y[0];

    wire next_y1 = (isB & ~w) | isC | (isD & ~w) | (isE & w) | isF;

    assign Y1 = next_y1;

endmodule