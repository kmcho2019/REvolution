module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        out_and = &in;
        out_or = |in;
        out_xor = ^in;
    end

endmodule