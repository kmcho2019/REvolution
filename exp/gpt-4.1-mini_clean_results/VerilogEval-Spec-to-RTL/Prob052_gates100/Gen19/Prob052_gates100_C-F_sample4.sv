module TopModule (
    input  [99:0] in,
    output reg    out_and,  // 100-input AND
    output reg    out_or,   // 100-input OR
    output reg    out_xor   // 100-input XOR (parity)
);

    always @(*) begin
        // Use built-in reduction operators for efficient logic synthesis
        out_and = &in;
        out_or  = |in;
        out_xor = ^in;
    end

endmodule