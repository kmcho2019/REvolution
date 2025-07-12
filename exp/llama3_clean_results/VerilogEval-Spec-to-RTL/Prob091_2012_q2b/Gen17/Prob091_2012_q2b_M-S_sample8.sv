module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly implement the next-state logic for Y1 and Y3
    always @(*) begin
        Y1 = w & y[0]; // Next state for Y1 (y[1])
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]); // Next state for Y3 (y[3])
    end

endmodule