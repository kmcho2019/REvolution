module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    reg [2:0] or_bitwise_tmp;
    reg       or_logical_tmp;
    reg [5:0] not_concat_tmp;

    always @(*) begin
        or_bitwise_tmp = a | b;
        or_logical_tmp = |a | |b;
        not_concat_tmp = {~b, ~a};

        out_or_bitwise = or_bitwise_tmp;
        out_or_logical = or_logical_tmp;
        out_not        = not_concat_tmp;
    end

endmodule