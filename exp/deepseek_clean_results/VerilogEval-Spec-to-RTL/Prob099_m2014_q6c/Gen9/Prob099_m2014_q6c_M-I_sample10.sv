module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is active in states E (y[4]) and F (y[5])
    assign Y1 = y[4] | y[5];

    // Y3 is active when:
    // In A and w=1 (stay in A)
    // In B/C/D/E/F and w=1 (transition to D or A)
    assign Y3 = (y[0] & w) |           // State A
                (y[1] & w) |           // State B
                (y[2] & w) |           // State C
                (y[3] & w) |           // State D
                (y[4] & w) |           // State E
                (y[5] & w);            // State F

endmodule