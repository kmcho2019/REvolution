module TopModule(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise-OR, logical-OR, and inverse (NOT) of both vectors
    always @(*) begin
        // Compute bitwise-OR
        out_or_bitwise = a | b;

        // Compute logical-OR
        out_or_logical = (|a) || (|b);

        // Compute inverse (NOT) of both vectors
        out_not = {~b, ~a};
    end

endmodule