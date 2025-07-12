module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Determine next state based on current state and input w
    assign Y1 = (y[0] && !w) ||  // A to B
                 (y[1] && w);  // B to C

    assign Y3 = (y[2] && !w) ||  // C to D
                 (y[3] && !w) ||  // D to A
                 (y[4] && !w);  // E to D
endmodule