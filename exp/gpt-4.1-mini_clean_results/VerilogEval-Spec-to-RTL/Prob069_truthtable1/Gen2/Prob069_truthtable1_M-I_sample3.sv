module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output reg f
);

    // Implement the function based on truth table:
    // f = (~x3 & x2) | (x3 & x1)
    always @(*) begin
        f = (~x3 & x2) | (x3 & x1);
    end

endmodule