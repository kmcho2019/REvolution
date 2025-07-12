module TopModule (
    input [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    // Internal signals (not strictly needed but shows alternative style)
    wire and_result;
    wire or_result;
    wire xor_result;

    // Compute reduction operations
    assign and_result = &in;
    assign or_result  = |in;
    assign xor_result = ^in;

    // Output assignments through always block
    always @* begin
        out_and = and_result;
        out_or  = or_result;
        out_xor = xor_result;
    end

endmodule