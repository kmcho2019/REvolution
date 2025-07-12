module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    always @(*) begin
        // Compute bitwise OR
        out_or_bitwise = a | b;

        // Compute logical OR
        out_or_logical = (a != 3'b000) || (b != 3'b000);

        // Compute inverse of a and b, and assign to out_not
        out_not[5:3] = ~b;
        out_not[2:0] = ~a;
    end

endmodule