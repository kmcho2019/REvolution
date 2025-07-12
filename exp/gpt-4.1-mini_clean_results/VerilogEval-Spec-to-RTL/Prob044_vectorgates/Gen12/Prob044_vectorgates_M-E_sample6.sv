module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    reg [2:0] or_result;
    reg [2:0] not_a;
    reg [2:0] not_b;

    always @* begin
        or_result = a | b;
        not_a = ~a;
        not_b = ~b;

        out_or_bitwise = or_result;
        out_or_logical = |or_result;
        out_not = {not_b, not_a};
    end

endmodule