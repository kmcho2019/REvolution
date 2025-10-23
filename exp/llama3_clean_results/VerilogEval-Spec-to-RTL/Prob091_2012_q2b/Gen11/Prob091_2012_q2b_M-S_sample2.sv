module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Direct implementation of next state logic for Y1 and Y3
    always @(*) begin
        Y1 = w & y[0]; // State B can be reached from A when w is 1
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // State D can be reached from B, C, E, F when w is 0
    end

endmodule