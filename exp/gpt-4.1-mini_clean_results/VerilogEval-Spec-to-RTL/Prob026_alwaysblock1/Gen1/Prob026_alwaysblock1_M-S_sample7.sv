module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Compute AND once with assign
    assign out_assign = a & b;

    // Derive out_alwaysblock from out_assign
    always @(*) begin
        out_alwaysblock = out_assign;
    end

endmodule