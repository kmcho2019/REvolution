module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Intermediate combinational signals
    wire [2:0] or_bitwise;
    wire       or_logical;
    wire [5:0] not_concat;

    always @(*) begin
        // Bitwise OR of inputs
        or_bitwise = a | b;

        // Logical OR reduction of combined inputs
        or_logical = |{a, b};

        // Concatenate inverted b and inverted a
        not_concat = {~b, ~a};
    end

    // Assign to outputs
    assign out_or_bitwise = or_bitwise;
    assign out_or_logical = or_logical;
    assign out_not        = not_concat;

endmodule