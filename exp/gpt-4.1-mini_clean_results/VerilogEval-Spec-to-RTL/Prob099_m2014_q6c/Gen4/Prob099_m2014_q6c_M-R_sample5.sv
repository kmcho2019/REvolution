module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

always @(*) begin
    // Next state B (y[1]) = A and ~w
    Y1 = y[0] & ~w;
    // Next state D (y[3]) = w and (B or C or E or F)
    Y3 = w & (y[1] | y[2] | y[4] | y[5]);
end

endmodule