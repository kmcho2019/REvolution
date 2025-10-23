module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    // Next-state logic for y[1] using a case statement
    assign Y1 = (y == 3'b000)? ~w :  // A (0) --0--> B, A (0) --1--> A
              (y == 3'b001)? w :  // B (0) --0--> C, B (0) --1--> D
              (y == 3'b010)? w :  // C (0) --0--> E, C (0) --1--> D
              (y == 3'b011)? ~w : // D (0) --0--> F, D (0) --1--> A
              (y == 3'b100)? w :  // E (1) --0--> E, E (1) --1--> D
              (y == 3'b101)? ~w : // F (1) --0--> C, F (1) --1--> D
              1'b0;                // Default value
endmodule