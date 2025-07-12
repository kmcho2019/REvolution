module TopModule (
    input [2:0] a,
    input [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg out_or_logical,
    output reg [5:0] out_not
);

    wire [2:0] not_a, not_b;
    wire a_any, b_any;

    always @(*) begin
        // Bitwise OR
        out_or_bitwise = a | b;

        // Logical OR (any bit in a OR any bit in b)
        a_any = |a;
        b_any = |b;
        out_or_logical = a_any | b_any;

        // NOT operations
        not_a = ~a;
        not_b = ~b;
        out_not = {not_b, not_a};
    end

endmodule