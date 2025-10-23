module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Directly compute next state's y[1] based on current state and input w
    assign Y1 = 
        (~y[2] & ~y[1] & ~y[0] & ~w) ? 0 : // A to B
        (~y[2] & ~y[1] & y[0] & ~w) ? 1 : // B to C or D
        (~y[2] & y[1] & ~y[0] & ~w) ? 1 : // C to E
        (~y[2] & y[1] & y[0] & ~w) ? 1 : // D to F or A
        (y[2] & ~y[1] & ~y[0] & ~w) ? 1 : // E stays in E
        (y[2] & y[1] & ~y[0] & ~w) ? 0 : // F to C
        1'b0; // Default to 0 for other cases

endmodule