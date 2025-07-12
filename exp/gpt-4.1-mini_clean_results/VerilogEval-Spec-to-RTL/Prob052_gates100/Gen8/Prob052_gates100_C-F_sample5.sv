module TopModule (
    input  [99:0] in,
    output reg    out_and,  // AND of all inputs
    output reg    out_or,   // OR of all inputs
    output reg    out_xor   // XOR of all inputs (parity)
);

    always @(*) begin
        out_and = &in;
        out_or  = |in;
        out_xor = ^in;
    end

endmodule