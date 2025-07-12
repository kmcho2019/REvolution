module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);
    integer i;
    reg [2:0] not_a;
    reg [2:0] not_b;

    always @* begin
        // Compute bitwise OR and bitwise NOTs per bit
        for (i = 0; i < 3; i = i + 1) begin
            out_or_bitwise[i] = a[i] | b[i];
            not_a[i] = ~a[i];
            not_b[i] = ~b[i];
        end

        // Assign the inverted vectors concatenated to out_not
        out_not = {not_b, not_a};

        // Logical OR reduction of bitwise OR output
        out_or_logical = |out_or_bitwise;
    end

endmodule