module TopModule(
    input  [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(in) begin
        out_and = &in; // Using the reduction AND operator
        out_or  = |in; // Using the reduction OR operator
        out_xor = ^in; // Using the reduction XOR operator
    end

endmodule