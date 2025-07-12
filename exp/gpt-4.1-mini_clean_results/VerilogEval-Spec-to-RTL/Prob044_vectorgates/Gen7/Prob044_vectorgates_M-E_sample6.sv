module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @(*) begin
        // Intermediate computations
        reg [2:0] or_val;
        reg [2:0] not_a;
        reg [2:0] not_b;

        or_val = a | b;
        not_a = ~a;
        not_b = ~b;

        out_or_bitwise = or_val;
        out_or_logical = |or_val;     // reduction OR of the OR result
        out_not = {not_b, not_a};
    end

endmodule