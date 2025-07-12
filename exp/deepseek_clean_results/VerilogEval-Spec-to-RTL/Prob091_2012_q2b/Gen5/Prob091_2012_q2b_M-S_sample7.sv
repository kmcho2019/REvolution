module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 remains optimally simple
    assign Y1 = y[0] & w;

    // Simplified Y3 using reduction OR for cleaner code
    assign Y3 = ~w & |{y[1], y[2], y[4], y[5]};

endmodule