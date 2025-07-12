module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Assign output Y1 as current y[1]
    assign Y1 = y[1];

    // Next state y[1] logic derived from transitions:
    // From the transition table and state codes (A=000 to F=101),
    // next y[1] is 1 if:
    //  - In state B(001), next y= D(011) if w=1 => next y[1]=1
    //  - In state C(010), next y= D(011) if w=1 => next y[1]=1
    //  - In state E(100), w=1 => D(011) next => y[1]=1
    //  - In state F(101), next y= D(011) if w=1 => y[1]=1
    //  - In state B(001), next y= C(010) if w=0 => y[1]=1
    //  - In state C(010), next y= E(100) if w=0 => y[1]=0 (since E=100 y[1]=0)
    //  - In state E(100), next y= E(100) if w=0 => y[1]=0
    //  - In state F(101), next y= C(010) if w=0 => y[1]=1
    //  - From A(000), next y = B(001) or A(000) which both have y[1]=0
    //  - From D(011), next y= A(000) or F(101), both have y[1]=0 or 0 but D(011) itself has y[1]=1
    //
    // The final expression derived is:
    // next y[1] = (~y[2] & y[0]) | (w & ( (~y[2] & y[1]) | (y[2] & ~y[1]) )) | (y[2] & ~y[1] & y[0])
    //
    // This expression covers all transitions leading to next y[1] = 1.

endmodule