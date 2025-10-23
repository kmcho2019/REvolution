module TopModule (
    input  [99:0] in,
    output reg    out_and,  // 100-input AND
    output reg    out_or,   // 100-input OR
    output reg    out_xor   // 100-input XOR (parity)
);

    integer i;
    always @(*) begin
        // Initialize outputs to identity values for each reduction
        out_and = 1'b1;
        out_or  = 1'b0;
        out_xor = 1'b0;

        // Compute reductions manually with a loop
        for (i = 0; i < 100; i = i + 1) begin
            out_and = out_and & in[i];
            out_or  = out_or  | in[i];
            out_xor = out_xor ^ in[i];
        end
    end

endmodule