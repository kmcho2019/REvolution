module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire next_y1;

    // Current state bits for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next state logic for y[1] based on the FSM transitions:
    // States A=000, B=001, C=010, D=011, E=100, F=101
    //
    // From the FSM transitions:
    // For each current state and input w, determine next state's y[1].
    //
    // Using the state codes:
    // A(000): y1=0
    // B(001): y1=0
    // C(010): y1=1
    // D(011): y1=1
    // E(100): y1=0
    // F(101): y1=0
    //
    // Next states for each current state and input w:
    // A(000): w=0 -> B(001) y1=0, w=1 -> A(000) y1=0
    // B(001): w=0 -> C(010) y1=1, w=1 -> D(011) y1=1
    // C(010): w=0 -> E(100) y1=0, w=1 -> D(011) y1=1
    // D(011): w=0 -> F(101) y1=0, w=1 -> A(000) y1=0
    // E(100): w=0 -> E(100) y1=0, w=1 -> D(011) y1=1
    // F(101): w=0 -> C(010) y1=1, w=1 -> D(011) y1=1

    // Build the next_y1 logic expression:

    // Evaluate for each state with current y and w:
    // 1) If y=001 (B) then next_y1=1 (both w=0,1)
    // 2) If y=010 (C) then next_y1 = w (0->0,1->1)
    // 3) If y=011 (D) then next_y1=0 (both w=0,1)
    // 4) If y=100 (E) then next_y1 = w (0->0,1->1)
    // 5) If y=101 (F) then next_y1=1 (both w=0,1)
    // 6) If y=000 (A) then next_y1=0 (both w=0,1)

    // Express conditions in terms of y bits:
    // B: y=001 => y2=0 y1=0 y0=1
    wire isB = (~y2) & (~y1) & y0;

    // C: y=010 => y2=0 y1=1 y0=0
    wire isC = (~y2) & y1 & (~y0);

    // D: y=011 => y2=0 y1=1 y0=1
    wire isD = (~y2) & y1 & y0;

    // E: y=100 => y2=1 y1=0 y0=0
    wire isE = y2 & (~y1) & (~y0);

    // F: y=101 => y2=1 y1=0 y0=1
    wire isF = y2 & (~y1) & y0;

    // Next y1 calculation:
    // For B and F, next_y1=1 regardless of w
    // For C and E, next_y1 = w
    // For others (A and D), next_y1=0

    assign next_y1 = (isB | isF) | ((isC | isE) & w);

    assign Y1 = y1;

endmodule