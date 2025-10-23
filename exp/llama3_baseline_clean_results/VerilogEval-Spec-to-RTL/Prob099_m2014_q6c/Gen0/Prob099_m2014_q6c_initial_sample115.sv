module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Since Y1 corresponds to state B (000010), it will be 1 only when the next state is B.
    // State A (000001) goes to B on w = 0, and state D (001000) goes to B on w = 0 and state E (010000) goes to D on w = 1 then D goes to B on w = 0, state F (100000) goes to C on w = 0 and C can go to D on w = 1 then D can go to B on w = 0
    // So, Y1 (next state B) will be 1 if current state is A and w = 0, or if current state is D and w = 0 and previous state was E or F and w = 0 in previous cycle.
    assign Y1 = (y[0] && !w) || ((y[3] && !w) && (y[4] || y[5]));

    // Since Y3 corresponds to state D (001000), it will be 1 only when the next state is D.
    // State B (000010) goes to D on w = 1, state C (000100) goes to D on w = 1, state D (001000) goes to A on w = 0 then A can go to B on w = 0 and B can go to D on w = 1, and state E (010000) goes to D on w = 0, and state F (100000) goes to C on w = 0 then C can go to D on w = 1
    // So, Y3 (next state D) will be 1 if current state is B and w = 1, or if current state is C and w = 1, or if current state is E and w = 0.
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && !w);

endmodule