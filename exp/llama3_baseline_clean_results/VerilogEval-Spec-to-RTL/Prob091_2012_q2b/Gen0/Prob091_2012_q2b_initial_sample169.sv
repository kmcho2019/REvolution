module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // One-hot encoding for states: A(000001), B(000010), C(000100), D(001000), E(010000), F(100000)
    // Y1 is high when next state is B (000010) or E (010000)
    assign Y1 = (y[0] && !w) || // A(000001) with w=0 goes to B
               (y[1] && w) ||  // B(000010) with w=1 goes to C
               (y[2] && w) ||  // C(000100) with w=1 goes to E
               (y[4] && w);    // E(010000) with w=1 stays in E

    // Y3 is high when next state is D (001000)
    assign Y3 = (y[1] && !w) || // B(000010) with w=0 goes to D
               (y[2] && !w) || // C(000100) with w=0 goes to D
               (y[3] && w) ||  // D(001000) with w=1 goes to F
               (y[4] && !w) || // E(010000) with w=0 goes to D
               (y[5] && !w);   // F(100000) with w=0 goes to D
endmodule