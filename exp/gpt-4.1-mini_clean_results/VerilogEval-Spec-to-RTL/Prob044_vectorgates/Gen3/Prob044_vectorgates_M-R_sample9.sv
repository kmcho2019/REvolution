module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @(*) begin
        // Compute bitwise OR of inputs
        out_or_bitwise = a | b;

        // Compute logical OR: true if any bit set in a or b
        out_or_logical = (|a) | (|b);

        // Compute inverted inputs and concatenate
        out_not = {~b, ~a};
    end

endmodule