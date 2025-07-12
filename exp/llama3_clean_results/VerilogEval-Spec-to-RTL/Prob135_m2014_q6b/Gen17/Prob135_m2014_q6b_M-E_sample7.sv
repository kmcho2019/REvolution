module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Using a Karnaugh map to simplify the next-state logic for y[1]
    assign Y1 = 
        // State A (000) to State B (001) or State A (000)
        (~y[2] & ~y[1] & ~y[0] & ~w)? 1'b1 :
        // State B (001) to State C (010) or State D (011)
        (~y[2] & ~y[1] & y[0] & ~w)? 1'b1 :
        // State C (010) to State E (100) or State D (011)
        (~y[2] & y[1] & ~y[0] & ~w)? 1'b1 :
        // State D (011) to State F (101) or State A (000)
        (~y[2] & y[1] & y[0] & ~w)? 1'b1 :
        // State E (100) to State E (100) or State D (011)
        (y[2] & ~y[1] & ~y[0] & ~w)? 1'b1 :
        // State F (101) to State C (010) or State D (011)
        (y[2] & y[1] & y[0] & ~w)? 1'b0 :
        // Other cases
        1'b0;

endmodule