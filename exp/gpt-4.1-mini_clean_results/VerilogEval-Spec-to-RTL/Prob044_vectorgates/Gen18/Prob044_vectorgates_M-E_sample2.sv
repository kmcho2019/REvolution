module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @(*) begin
        // Bitwise OR of inputs
        out_or_bitwise = a | b;

        // Logical OR: true if any bit in a or b is 1
        out_or_logical = (|a) || (|b);

        // Inversion: out_not[5:3] = ~b, out_not[2:0] = ~a
        out_not = {~b, ~a};
    end

endmodule