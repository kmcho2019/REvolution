module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Continuous assignment with case statement
assign f = (
    (x3 == 0 && x2 == 0 && x1 == 0) ? 0 :
    (x3 == 0 && x2 == 0 && x1 == 1) ? 0 :
    (x3 == 0 && x2 == 1 && x1 == 0) ? 1 :
    (x3 == 0 && x2 == 1 && x1 == 1) ? 1 :
    (x3 == 1 && x2 == 0 && x1 == 0) ? 0 :
    (x3 == 1 && x2 == 0 && x1 == 1) ? 1 :
    (x3 == 1 && x2 == 1 && x1 == 0) ? 0 :
    (x3 == 1 && x2 == 1 && x1 == 1) ? 1 :
    0 // default value
);

endmodule